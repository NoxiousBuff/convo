import 'dart:io';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/api/background_downloader.dart';
import 'package:hint/ui/shared/download_button.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/shared/convo_image/convo_image_viewmodel.dart';

class ConvoImage extends StatefulWidget {
  /// make sure that the hive box is already opened
  final String? imageName;
  final String hiveBoxName;
  final String folderPath;
  final VoidCallback? onTap;
  final Message message;
  const ConvoImage({
    Key? key,
    required this.hiveBoxName,
    required this.folderPath,
    this.imageName,
    this.onTap,
    required this.message,
  }) : super(key: key);

  @override
  _ConvoImageState createState() => _ConvoImageState();
}

class _ConvoImageState extends State<ConvoImage> {
  /// API
  DioApi dioApi = DioApi();
  PathHelper pathHelper = PathHelper();

  final log = getLogger('ConvoImage');

  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;

  @override
  void initState() {
    bool containPath =
        Hive.box(widget.hiveBoxName).containsKey(widget.message.messageUid);

    if (widget.message.senderUid != currentUserUid) {
      if (!containPath) generalWorker();
    }
    super.initState();
  }

  /// This will download the thumbnail image and save it locally in hive database
  void generalWorker() async {
    final now = DateTime.now();
    final day = now.day;
    final year = now.year;
    final month = now.month;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-IMG-$uploadingTime';
    await BackgroundDownloader().saveMediaAtPath(
      extension: 'jpeg',
      mediaName: imageName,
      folderPath: widget.folderPath,
      messageUid: widget.message.messageUid,
      mediaURL: widget.message.message[MessageField.mediaUrl],
    );
  }

  /// This widget will display image if path is saved in hive database
  Widget imageDisplay(Box<dynamic> box) {
    String path = box.get(widget.message.messageUid);
    bool iSend = widget.message.senderUid == currentUserUid;
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
                  BlurHash(hash: widget.message.message[MessageField.blurHash]),
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
                          buttonTitle:
                              widget.message.message[MessageField.size]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Message _message = widget.message;

    /// Check if message was sended by me OR receive this message
    bool iSend = _message.senderUid == currentUserUid;

    /// This is the hash of blurhash
    String hash = _message.message[MessageField.blurHash];

    /// Size in bytes of Image
    int size = _message.message[MessageField.size];

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        return ViewModelBuilder<ConvoImageViewModel>.reactive(
          viewModelBuilder: () => ConvoImageViewModel(),
          builder: (context, model, child) {
            return box.containsKey(widget.message.messageUid)
                ? imageDisplay(box)
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
                                    buttonTitle: filesize(size),
                                    onTap: () => generalWorker(),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
