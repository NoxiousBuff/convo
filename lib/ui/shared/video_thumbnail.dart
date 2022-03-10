import 'dart:io';
import 'download_button.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/path_finder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/video_thumbnail.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/api/background_downloader.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:video_compress_ds/video_compress_ds.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class VideoThumbnail extends StatefulWidget {
  //make sure that the hive box is already opened
  // final String mediaUrl;
  final String hiveBoxName;
  final String folderPath;
  final VoidCallback? onTap;
  //final String messageUid;
  final Message message;
  const VideoThumbnail({
    Key? key,
    required this.hiveBoxName,
    required this.folderPath,
    this.onTap,
    required this.message,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;

  final log = getLogger('VideoThumbnail');

  @override
  void initState() {
    bool containPath =
        Hive.box(widget.hiveBoxName).containsKey(widget.message.messageUid);

    if (widget.message.senderUid != currentUserUid) {
      if (!containPath) generalWorker();
    }
    super.initState();
  }

  /// Generate the thumbnail od received video and return the file
  Future<File> thumbnailGenerate(String videoPath) async {
    var thumbnail =
        await VideoCompress.getFileThumbnail(videoPath, quality: 50);

    return File(thumbnail.path);
  }

  /// This will download the thumbnail image and save it locally in hive database
  void generalWorker() async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-IMG-$uploadingTime';
    final thumbnailFile =
        await thumbnailGenerate(widget.message.message[MessageField.mediaUrl]);

    /// Download the received video and save it convo application folder
    await BackgroundDownloader().saveMediaAtPath(
      extension: 'mp4',
      mediaName: imageName,
      folderPath: widget.folderPath,
      messageUid: widget.message.messageUid,
      mediaURL: widget.message.message[MessageField.mediaUrl],
    );

    /// Save the thumbnail locally in convo application folder and
    /// store the path of thumbnail in hive database
    pathFinder.saveInLocalPath(
      thumbnailFile,
      extension: 'jpeg',
      mediaName: imageName,
      folderPath: 'Media/Thumbnails',
    );
  }

  /// Thumbnail Widget of video
  Widget videoThumbnail(Box<dynamic> box) {
    Message _message = widget.message;

    ///  get hiveBox details
    final hive = box.get(_message.messageUid);

    /// convert it into a Map<String,dynamic>
    final map = Map<String, dynamic>.from(hive);

    /// And get the path of video thumbnail
    final path = VideoThumbnailModel.fromJson(map).videoThumbnailPath;

    /// check wether I send this mesage OR receive
    bool iSend = _message.senderUid == currentUserUid;

    /// Size in bytes of video
    int size = _message.message[MessageField.size];

    const String description = 'Sorry, this media file appears to be missing';
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            File(path),
            errorBuilder: (context, object, StackTrace? stackTrace) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  BlurHash(hash: _message.message[MessageField.blurHash]),
                  iSend
                      ? DownloadButton(
                          buttonTitle: 'Download',
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return DuleAlertDialog(
                                title: 'Missing Media',
                                description: description,
                                icon: FeatherIcons.info,
                                primaryButtonText: 'OK',
                                primaryOnPressed: () => Navigator.pop(context),
                              );
                            },
                          ),
                        )
                      : DownloadButton(
                          onTap: () => generalWorker(),
                          buttonTitle: filesize(size),
                        ),
                ],
              );
            },
          ),
          //TODO: This circle avatar appears if there is an error to open filePath
          //TODO: Can't find a solution now , if there is an error in errorBuilder of image then this circle avatar must be disappears
          CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.black.withOpacity(0.8),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                FeatherIcons.play,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        Message _message = widget.message;

        /// This is the hash of blurhash
        String hash = _message.message[MessageField.blurHash];

        bool iSend = _message.senderUid == currentUserUid;
        return box.containsKey(widget.message.messageUid)
            ? videoThumbnail(box)
            : GestureDetector(
                onTap: widget.onTap,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    iSend
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              BlurHash(hash: hash),
                              DownloadButton(
                                buttonTitle: 'Download',
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DuleAlertDialog(
                                      title: 'Missing Media',
                                      description:
                                          'Sorry, this media file appears to be missing',
                                      icon: FeatherIcons.info,
                                      primaryButtonText: 'OK',
                                      primaryOnPressed: () =>
                                          Navigator.pop(context),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              BlurHash(hash: hash),
                              DownloadButton(
                                buttonTitle:
                                    _message.message[MessageField.size],
                                onTap: () => generalWorker(),
                              ),
                            ],
                          ),
                  ],
                ),
              );
      },
    );
  }
}
