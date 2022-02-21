import 'dart:ui';
import 'dart:typed_data';
import 'package:hint/api/hive_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_widget.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/ui/components/media/video/video_viewmodel.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class VideoMedia extends StatelessWidget {
  final bool isRead;
  final String videoPath;
  final String messageUid;
  final String receiverUid;
  final String conversationId;
  final Uint8List videoThumbnail;
  final MessageBubbleViewModel messageBubbleModel;
  VideoMedia({
    Key? key,
    required this.isRead,
    required this.receiverUid,
    required this.messageUid,
    required this.videoPath,
    required this.videoThumbnail,
    required this.conversationId,
    required this.messageBubbleModel,
  }) : super(key: key);

  final log = getLogger('VideoMedia');

  Widget uploadingProgress(MessageBubbleViewModel model) {
    return Positioned(
      bottom: 5,
      left: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            model.taskState == TaskState.running
                ? CircularProgressIndicator(
                    backgroundColor: systemBackground,
                    value: model.uploadingProgress,
                  )
                : const CircularProgressIndicator(
                    backgroundColor: systemBackground,
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
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final hiveBox = thumbnailsPathHiveBox(conversationId);
    return ViewModelBuilder<VideoViewModel>.reactive(
      viewModelBuilder: () => VideoViewModel(),
      onModelReady: (model) async {
        if (!hiveBox.containsKey(messageUid)) {
          log.w('hive doesn\'t contain path of MessageUid:$messageUid');
          await model.uploadAndSave(
            filePath: videoPath,
            messageUid: messageUid,
            model: messageBubbleModel,
            conversationId: conversationId,
          );
        }
      },
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveBox.listenable(),
          builder: (context, box, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                mediaBubble(
                    context: context,
                    isRead: isRead,
                    child: !hiveBox.containsKey(messageUid)
                        ? ExtendedImage(image: MemoryImage(videoThumbnail))
                        : ExtendedImage(
                            enableLoadState: true,
                            handleLoadingProgress: true,
                            image: FileImage(File(hiveBox.get(messageUid))))),
                !box.containsKey(messageUid)
                    ? messageBubbleModel.isuploading
                        ? uploadingProgress(messageBubbleModel)
                        : retryButton()
                    : const CircleAvatar(
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
              ],
            );
          },
        );
      },
    );
  }
}
