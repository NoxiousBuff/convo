import 'dart:ui';
import 'dart:typed_data';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/components/media/media_bubble/media_bubble.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/constants/message_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/ui/components/media/image/image_viewmodel.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class ImageMedia extends StatelessWidget {
  final bool isRead;
  final Message message;
  final String receiverUid;
  final String conversationId;
  final Uint8List memoryImage;
  final MessageBubbleViewModel messageBubbleModel;
  ImageMedia({
    Key? key,
    required this.isRead,
    required this.message,
    required this.memoryImage,
    required this.receiverUid,
    required this.conversationId,
    required this.messageBubbleModel,
  }) : super(key: key);

  final radius = BorderRadius.circular(16);
  final log = getLogger('ImageMedia');
  Widget retryButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload, color: systemBackground),
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
          ),
        ),
      ),
    );
  }

  Widget uploadingProgress(MessageBubbleViewModel model) {
    return Positioned(
      bottom: 5,
      left: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            messageBubbleModel.taskState == TaskState.running
                ? CircularProgressIndicator(
                    value: model.uploadingProgress,
                    backgroundColor: systemBackground,
                  )
                : const CircularProgressIndicator(
                    backgroundColor: systemBackground),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var hiveBox = hiveApi.chatRoomMediaHiveBox(conversationId);

    return ViewModelBuilder<ImageViewModel>.reactive(
      viewModelBuilder: () => ImageViewModel(),
      onModelReady: (model) async {
        if (!hiveBox.containsKey(message.messageUid)) {
          log.w('uploaded is false for this message');
          await model.uploadAndSave(
            model: messageBubbleModel,
            messageUid: message.messageUid,
            conversationId: conversationId,
            filePath: message.message[MessageField.mediaURL],
          );
        }
      },
      builder: (context, model, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            mediaBubble(
              context: context,
              isRead: isRead,
              child: !hiveBox.containsKey(message.messageUid)
                  ? ExtendedImage(image: MemoryImage(memoryImage))
                  : ExtendedImage.file(File(hiveBox.get(message.messageUid))),
            ),
            ValueListenableBuilder<Box>(
              valueListenable: hiveBox.listenable(),
              builder: (context, box, child) {
                return !box.containsKey(message.messageUid)
                    ? messageBubbleModel.isuploading
                        ? uploadingProgress(messageBubbleModel)
                        : message.message[MessageField.uploaded]
                            ? retryButton()
                            : const SizedBox.shrink()
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }
}
