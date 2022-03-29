import 'package:dio/dio.dart';
import 'package:hint/api/path.dart';
import 'package:hint/api/hive.dart';
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
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
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
          },
        );
      },
    );
  }
}
