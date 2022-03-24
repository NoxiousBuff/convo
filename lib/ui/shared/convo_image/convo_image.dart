import 'package:dio/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/download_button.dart';
import 'package:hint/ui/shared/circular_progress.dart';
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
  PathHelper pathHelper = PathHelper();

  /// calling firestoreAPI
  FirestoreApi firestoreApi = FirestoreApi();

  final log = getLogger('ConvoImage');

  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;

  // * This function runs when widget is appears in widget tree
  @override
  void initState() {
    if (widget.message.senderUid != currentUserUid) {
      bool containKey =
          widget.message.message.containsKey(MessageField.receiverLocalPath);
      if (!containKey) generalWorker();
    }
    super.initState();
  }

  /// This will download the thumbnail image and save it locally in hive database
  void generalWorker() async {
    final _message = widget.message;
    final _messageMap = _message.message;
    final fileName = pathHelper.receivedMediaName(MediaType.image);
    final uri = Uri.parse(_message.message[MessageField.mediaUrl]);
    final directory = pathHelper.getSavedDirecotyPath(widget.folderPath);

    String savedPath = '$directory/$fileName.jpeg';
    await Dio().downloadUri(uri, savedPath);
    final map = <String, String>{MessageField.receiverLocalPath: savedPath};
    _messageMap.addEntries(map.entries);

    await firestoreApi.updateUser(
        uid: currentUserUid,
        value: _messageMap,
        propertyName: DocumentField.message);
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
                          buttonTitle: filesize(
                            widget.message.message[MessageField.size],
                          ),
                        ),
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
    //bool iSend = _message.senderUid == currentUserUid;

    /// This is the hash of blurhash
    String hash = _message.message[MessageField.blurHash];

    /// This is the LinkedHashMap<String, dynamic> of message from firestore
    final _messageMap = _message.message;

    /// Size in bytes of Image
    int size = _message.message[MessageField.size];

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        return ViewModelBuilder<ConvoImageViewModel>.reactive(
          viewModelBuilder: () => ConvoImageViewModel(),
          builder: (context, model, child) {
            if (_message.senderUid == currentUserUid) {
              return ExtendedImage.file(
                File(_message.message[MessageField.senderLocalPath]),
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.failed:
                      {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            BlurHash(hash: hash),
                            DownloadButton(
                              buttonTitle: filesize(size),
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
                        return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          fit: BoxFit.cover,
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
              if (_messageMap.containsKey(MessageField.receiverLocalPath)) {
                return ExtendedImage.file(
                  File(_message.message[MessageField.receiverLocalPath]),
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.failed:
                        {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              BlurHash(hash: hash),
                              DownloadButton(
                                buttonTitle: filesize(size),
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
                          return ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                            fit: BoxFit.cover,
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
                  children: [
                    BlurHash(hash: hash),
                    DownloadButton(
                      buttonTitle: filesize(size),
                      onTap: () => generalWorker(),
                    )
                  ],
                );
              }
            }
            // return box.containsKey(widget.message.messageUid)
            //     ? imageDisplay(box)
            //     : GestureDetector(
            //         onTap: widget.onTap,
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             iSend
            //                 ? Stack(
            //                     alignment: Alignment.center,
            //                     children: [
            //                       BlurHash(hash: hash),
            //                       DownloadButton(
            //                         buttonTitle: 'Download',
            //                         onTap: () => showDialog(
            //                           context: context,
            //                           builder: (context) {
            //                             return DuleAlertDialog(
            //                               title: 'Missing Media',
            //                               description:
            //                                   'Sorry, this media file appears to be missing',
            //                               icon: FeatherIcons.info,
            //                               primaryButtonText: 'OK',
            //                               primaryOnPressed: () =>
            //                                   Navigator.pop(context),
            //                             );
            //                           },
            //                         ),
            //                       ),
            //                     ],
            //                   )
            //                 : Stack(
            //                     alignment: Alignment.center,
            //                     children: [
            //                       BlurHash(hash: hash),
            //                       DownloadButton(
            //                         buttonTitle: filesize(size),
            //                         onTap: () => generalWorker(),
            //                       ),
            //                     ],
            //                   ),
            //           ],
            //         ),
            //       );
          },
        );
      },
    );
  }
}
