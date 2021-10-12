import 'dart:ui';
import 'dart:typed_data';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/app/app_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';
import 'package:hint/ui/components/media/canvas_image/canvas_image_viewmodel.dart';

class CanvasImage extends StatelessWidget {
  final bool isRead;
  final Message message;
  final Uint8List imageData;
  final String conversationId;
  final MessageBubbleViewModel messageBubbleModel;
  const CanvasImage(
      {Key? key,
      required this.isRead,
      required this.message,
      required this.imageData,
      required this.conversationId,
      required this.messageBubbleModel})
      : super(key: key);

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
    final log = getLogger('CanvasImage');
    final messageUid = message.messageUid;
    var hiveBox = chatRoomMediaHiveBox(conversationId);
    return ViewModelBuilder<CanvasImageViewModel>.reactive(
      viewModelBuilder: () => CanvasImageViewModel(),
      onModelReady: (model) async {
        if (!hiveBox.containsKey(message.messageUid)) {
          log.d('MessageUid:${message.messageUid}');
          await model
              .uploadAndSave(
                  data: imageData,
                  model: messageBubbleModel,
                  messageUid: message.messageUid,
                  conversationId: conversationId)
              .catchError((e) {
            log.e(e);
          });
        }
      },
      builder: (context, model, child) {
        return mediaBubble(
            context: context,
            isRead: isRead,
            child: !hiveBox.containsKey(messageUid)
                ? ExtendedImage(image: MemoryImage(imageData))
                : ExtendedImage.file(File(hiveBox.get(messageUid))));
      },
    );
  }
}
