import 'package:dio/dio.dart';
import 'package:hint/api/path.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/thumbnail_api.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/download_button.dart';
import 'package:hint/models/media_display_model.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/shared/video_media/video_thumbnail_viewmodel.dart';

class VideoThumbnailView extends StatefulWidget {
  //make sure that the hive box is already opened
  // final String mediaUrl;
  final String hiveBoxName;

  /// folder path where video thumbnail will be saved
  final String folderPath;
  final VoidCallback? onTap;
  //final String messageUid;
  final Message message;
  const VideoThumbnailView({
    Key? key,
    required this.hiveBoxName,
    required this.folderPath,
    this.onTap,
    required this.message,
  }) : super(key: key);

  @override
  _VideoThumbnailViewState createState() => _VideoThumbnailViewState();
}

class _VideoThumbnailViewState extends State<VideoThumbnailView> {
  /// Get Instance of of GetIt OR create locator

  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;

  /// logger variable
  final log = getLogger('VideoThumbnailView');

  /// variable for calling PathHeling PathHelper Class
  final pathHelper = PathHelper();

  /// calling thumbnail API
  final thumbnailAPI = locator.get<ThumbnailAPI>();

  /// calling firestoreAPI
  FirestoreApi firestoreApi = FirestoreApi();

  @override
  void initState() {
    if (widget.message.senderUid != currentUserUid) {
      bool containKey =
          widget.message.message.containsKey(MessageField.receiverLocalPath);
      if (!containKey) generalWorker();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This will download the thumbnail image and save it locally in hive database
  void generalWorker() async {
    final _message = widget.message;
    final _messageMap = _message.message;
    final uri = Uri.parse(_message.message[MessageField.mediaUrl]);
    final videoName = pathHelper.receivedMediaName(MediaType.video);
    final thumbnailName = pathHelper.receivedMediaName(MediaType.image);
    final directory = pathHelper.getSavedDirecotyPath(widget.folderPath);

    String videoPath = '$directory/$videoName.mp4';
    await Dio().downloadUri(uri, videoPath);
    final thumbnail = await pathHelper.saveInLocalPath(File(videoPath),
        extension: 'jpeg',
        mediaName: thumbnailName,
        folderPath: 'Media/Thumbnails');
    final map = <String, String>{
      MessageField.receiverLocalPath: videoPath,
      MessageField.receiverThumbnail: thumbnail.path
    };
    _messageMap.addEntries(map.entries);

    await firestoreApi.updateUser(
        uid: currentUserUid,
        value: _messageMap,
        propertyName: DocumentField.message);
  }

  Future downloadMedia(VideoThumbnailViewModel model) async {
    String mediaName = pathHelper.receivedMediaName(MediaType.video);
    String _videoURL = widget.message.message[MessageField.mediaUrl];

    /// get the path of saved directory OR Folder Path
    /// where file will downloaded media saved
    /// Only Those media will saved which is received by current user not sended
    final savedDir = await pathHelper.getSavedDirecotyPath(widget.folderPath);

    /// Download the received video and save it convo application folder
    await model.downloadVideo(Uri.parse(_videoURL), '$savedDir/$mediaName.mp4');
  }

  /// This will download the thumbnail image and save it locally in hive database
  // void generalWorker(VideoThumbnailViewModel model) async {
  //   String mediaName = pathHelper.receivedMediaName(MediaType.video);
  //   String _videoURL = widget.message.message[MessageField.mediaUrl];
  //   GetIt.I.get<ThumbnailAPI>().getMounted(mounted);

  //   /// get the path of saved directory OR Folder Path
  //   /// where file will downloaded media saved
  //   /// Only Those media will saved which is received by current user not sended
  //   final savedDir = await pathHelper.getSavedDirecotyPath(widget.folderPath);

  //   /// Download the received video and save it convo application folder
  //   Map<String, dynamic> downloaderMap = await model.downloadVideo(
  //       savedDir: savedDir,
  //       videoURL: _videoURL,
  //       fileNameWithExtension: '$mediaName.mp4');

  //   /// get the data from isolate
  //   model.task(downloaderMap[FDRField.taskID]);

  //   /// get the data in stream from isolate
  //   /// e.g downloading prgress, Status, TaskID
  //   model.bindBackgroundIsolate();

  //   /// Generate the thumbnail of a video and return a thumbnail as a file
  //   // File thumbnail = await VideoCompress.getFileThumbnail(
  //   //     downloaderMap[FDRField.filePath],
  //   //     quality: 50);

  //   // /// save the thumbnail of video in convo application
  //   // /// thumbnail folder
  //   // final thumbnailPath = await pathHelper.saveInLocalPath(File(filePath!),
  //   //     extension: 'jpeg',
  //   //     mediaName: mediaName,
  //   //     folderPath: 'Media/Thumbnails');

  //   // final map = {
  //   //   MediaDisplayField.thumbnailPath: thumbnailPath,
  //   //   MediaDisplayField.taskID: downloaderMap[FDRField.taskID],
  //   //   MediaDisplayField.localPath: downloaderMap[FDRField.filePath],
  //   // };
  //   // // * Save data in hive database locally
  //   // await hiveApi
  //   //     .save(HiveApi.mediaHiveBox, widget.message.messageUid, map)
  //   //     .whenComplete(
  //   //         () => log.wtf('succesfully save in hive databse locally'));
  // }

  /// Thumbnail Widget of video
  /// This widget display the thumbnail of the video
  /// If video is available this will display thumbnail
  /// if not then this will display blur hash image using hash string
  /// which was saved in firestore database
  Widget videoThumbnail(Box<dynamic> box, VideoThumbnailViewModel model) {
    Message _message = widget.message;

    ///  get hiveBox details
    final hive = box.get(_message.messageUid);

    /// convert it into a Map<String,dynamic>
    final map = Map<String, dynamic>.from(hive);

    /// And get the path of video thumbnail
    final path = MediaDisplayModel.fromJson(map).thumbnailPath;

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
                          onTap: () {},
                          buttonTitle: filesize(size),
                        ),
                ],
              );
            },
          ),
          // TODO: This circle avatar appears if there is an error to open filePath
          // TODO: Can't find a solution now , if there is an error in errorBuilder of image then this circle avatar must be disappears
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

  /// display progress when media is downloading
  Widget displayProgress(VideoThumbnailViewModel model) {
    return ValueListenableBuilder<int>(
      valueListenable: model.valueNotifier,
      builder: (context, value, child) {
        return Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.all(4),
            child: Text(value.toString()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        Message _message = widget.message;

        // * This is the hash of blurhash
        String hash = _message.message[MessageField.blurHash];

        // * size of the media
        int fileSize = _message.message[MessageField.size];

        return ViewModelBuilder<VideoThumbnailViewModel>.reactive(
          viewModelBuilder: () => VideoThumbnailViewModel(),
          builder: (context, model, child) {
            if (_message.senderUid == currentUserUid) {
              return ExtendedImage.file(
                File(_message.message[MessageField.senderThumbnail]),
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.failed:
                      {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            BlurHash(hash: hash),
                            DownloadButton(
                              buttonTitle: filesize(fileSize),
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
                        );
                      }

                    case LoadState.loading:
                      {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            BlurHash(hash: hash),
                            const CircularProgress(),
                          ],
                        );
                      }
                    case LoadState.completed:
                      {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            ExtendedRawImage(
                              image: state.extendedImageInfo?.image,
                              fit: BoxFit.cover,
                            ),
                            CircleAvatar(
                              maxRadius: 35,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .black
                                  .withOpacity(0.8),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  FeatherIcons.play,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    default:
                      {
                        return shrinkBox;
                      }
                  }
                },
              );
            } else {
              var thumbnail = _message.message[MessageField.receiverThumbnail];
              if (_message.message.containsKey(thumbnail)) {
                return ExtendedImage.file(
                  File(thumbnail),
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.failed:
                        {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              BlurHash(hash: hash),
                              DownloadButton(
                                buttonTitle: filesize(fileSize),
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
                          );
                        }

                      case LoadState.loading:
                        {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              BlurHash(hash: hash),
                              const CircularProgress(),
                            ],
                          );
                        }
                      case LoadState.completed:
                        {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              ExtendedRawImage(
                                image: state.extendedImageInfo?.image,
                                fit: BoxFit.cover,
                              ),
                              CircleAvatar(
                                maxRadius: 35,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .black
                                    .withOpacity(0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    FeatherIcons.play,
                                    size: 30,
                                    color: Theme.of(context).colorScheme.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      default:
                        {
                          return shrinkBox;
                        }
                    }
                  },
                );
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    BlurHash(hash: hash),
                    DownloadButton(
                      buttonTitle: filesize(fileSize),
                      onTap: () => generalWorker(),
                    )
                  ],
                );
              }
            }
            // String uid = _message.messageUid;
            // if (box.containsKey(uid)) {
            //   Map<String, dynamic> map = Map.from(box.get(uid));
            //   return map[MediaHiveBoxField.thumbnailPath] != null
            //       ? videoThumbnail(box, model)
            //       : GestureDetector(
            //           onTap: widget.onTap,
            //           child: Stack(
            //             alignment: Alignment.center,
            //             children: [
            //               BlurHash(hash: hash),
            //               DownloadButton(
            //                 buttonTitle: filesize(fileSize),
            //                 onTap: () => iSend
            //                     ? showDialog(
            //                         context: context,
            //                         builder: (context) {
            //                           return DuleAlertDialog(
            //                             title: 'Missing Media',
            //                             description:
            //                                 'Sorry, this media file appears to be missing',
            //                             icon: FeatherIcons.info,
            //                             primaryButtonText: 'OK',
            //                             primaryOnPressed: () =>
            //                                 Navigator.pop(context),
            //                           );
            //                         },
            //                       )
            //                     : downloadMedia(model),
            //               ),
            //               displayProgress(model)
            //             ],
            //           ),
            //         );
            // } else {
            //   return GestureDetector(
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         BlurHash(hash: hash),
            //         DownloadButton(
            //           buttonTitle: filesize(fileSize),
            //           onTap: () => downloadMedia(model),
            //         ),
            //       ],
            //     ),
            //   );
            // }
          },
        );
      },
    );
  }
}
