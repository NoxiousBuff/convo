import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/hint_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/components/media/image/image_viewmodel.dart';

class ImageMedia extends StatelessWidget {
  final bool isMe;
  final String receiverUid;
  final String conversationId;
  final HintMessage hiveMessage;
  ImageMedia({
    Key? key,
    required this.isMe,
    required this.receiverUid,
    required this.hiveMessage,
    required this.conversationId,
  }) : super(key: key);

  final borderRadius = BorderRadius.circular(16);
  final ChatService chatService = ChatService();

  Widget imageWidget({required Widget child, required BuildContext context}) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: extraLightBackgroundGray, width: 5)),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.width * 0.2,
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.35,
        ),
        child: child,
      ),
    );
  }

  Widget uploadingProgress(ImageViewModel model) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: systemBackground,
          value: model.uploadingProgress,
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
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    return ViewModelBuilder<ImageViewModel>.reactive(
      viewModelBuilder: () => ImageViewModel(conversationId),
      onModelReady: (model) async {
        switch (hiveBox.containsKey(hiveMessage.messageUid)) {
          case false:
            {
              final msg = hiveMessage;
              final downloadUrl = await model.uploadFile(
                  messageUid: msg.messageUid, filePath: msg.mediaPaths);

              await chatService.addFirestoreMessage(
                type: msg.messageType,
                mediaUrls: downloadUrl,
                timestamp: msg.timestamp,
                messageUid: msg.messageUid,
                mediaUrlsType: msg.messageType,
                receiverUid: receiverUid,
              );
            }

            break;
          case true:
            {
              getLogger('ImageView').wtf('Hive contain Key');
            }
            break;
          default:
        }
      },
      builder: (context, model, child) {
        switch (hiveBox.containsKey(hiveMessage.messageUid)) {
          case true:
            {
              return imageWidget(
                context: context,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ExtendedImage(
                    filterQuality: FilterQuality.low,
                    image: FileImage(File(hiveMessage.mediaPaths)),
                  ),
                ),
              );
            }

          case false:
            {
              return imageWidget(
                context: context,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: borderRadius,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.width * 0.2,
                          minWidth: MediaQuery.of(context).size.width * 0.2,
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: ExtendedImage(
                          image: FileImage(
                            File(hiveMessage.mediaPaths),
                          ),
                        ),
                      ),
                    ),
                    model.busy(model.isuploading)
                        ? Positioned(
                            bottom: 5, left: 5, child: uploadingProgress(model))
                        : !hiveBox.containsKey(hiveMessage.messageUid)
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
                            : const SizedBox.shrink(),
                  ],
                ),
              );
            }
          default:
            {
              return const SizedBox.shrink();
            }
        }
      },
    );
  }
}
