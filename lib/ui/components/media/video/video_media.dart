import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/hint_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/components/media/video/video_viewmodel.dart';

class VideoMedia extends StatelessWidget {
  final bool isMe;
  final String conversationId;
  final HintMessage hiveMessage;
  final Uint8List videoThumbnail;
  final String receiverUid;
  VideoMedia({
    Key? key,
    required this.isMe,
    required this.receiverUid,
    required this.hiveMessage,
    required this.videoThumbnail,
    required this.conversationId,
  }) : super(key: key);

  final borderRadius = BorderRadius.circular(16);

  Widget videoWidget({required Widget child, required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: extraLightBackgroundGray, width: 5),
      ),
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        minWidth: MediaQuery.of(context).size.width * 0.2,
        maxWidth: MediaQuery.of(context).size.width * 0.65,
        minHeight: MediaQuery.of(context).size.width * 0.2,
      ),
      child: child,
    );
  }

  Widget uploadingProgress(VideoViewModel model) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: systemBackground,
          value: model.uploadingVideo,
        ),
        Opacity(
          opacity: 0.5,
          child: CircleAvatar(
            maxRadius: 18,
            backgroundColor: black54,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.clear,
                color: systemBackground,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageUid = hiveMessage.messageUid;
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");

    return ViewModelBuilder<VideoViewModel>.reactive(
      viewModelBuilder: () => VideoViewModel(conversationId),
      onModelReady: (model) async {
        getLogger('ImageMedia')
            .wtf('hiveContainPath:${hiveBox.containsKey(messageUid)}');
        if (!hiveBox.containsKey(messageUid)) {
          final msg = hiveMessage;
          final downloadUrl = await model.uploadFile(
              messageUid: msg.messageUid, filePath: msg.mediaPaths);

          await chatService.addFirestoreMessage(
            type: msg.messageType,
            mediaUrls: downloadUrl,
            timestamp: msg.timestamp,
            receiverUid: receiverUid,
            messageUid: msg.messageUid,
            mediaUrlsType: msg.messageType,
          );
        } else {
          getLogger('ImageView').wtf('Hive contain Key');
        }
      },
      builder: (context, model, child) {
        if (hiveBox.containsKey(hiveMessage.messageUid)) {
          return videoWidget(
            context: context,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                      minWidth: MediaQuery.of(context).size.width * 0.2,
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                      minHeight: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: ExtendedImage(
                      image: MemoryImage(videoThumbnail),
                    ),
                  ),
                ),
                const Center(
                  child: CircleAvatar(
                    maxRadius: 28,
                    backgroundColor: black54,
                    child: Center(
                      child: Icon(
                        CupertinoIcons.play_fill,
                        color: systemBackground,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return videoWidget(
            context: context,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                      minWidth: MediaQuery.of(context).size.width * 0.2,
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                      minHeight: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: ExtendedImage(
                      image: MemoryImage(videoThumbnail),
                    ),
                  ),
                ),
                model.busy(model.isuploading)
                    ? Positioned(
                        bottom: 5, left: 5, child: uploadingProgress(model))
                    : hiveBox.containsKey(hiveMessage.messageUid)
                        ? TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.upload,
                                    color: extraLightBackgroundGray),
                                const SizedBox(width: 10),
                                Text(
                                  'Retry',
                                  style: GoogleFonts.roboto(
                                    fontSize: 15.0,
                                    color: systemBackground,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const Center(
                            child: CircleAvatar(
                              maxRadius: 28,
                              backgroundColor: black54,
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.play_fill,
                                  color: systemBackground,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          );
        }
      },
    );
  }
}
