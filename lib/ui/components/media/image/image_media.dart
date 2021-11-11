import 'dart:ui';
import 'dart:typed_data';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_widget.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/constants/message_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/ui/components/media/image/image_viewmodel.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class ImageMedia extends StatefulWidget {
  final bool isRead;
  final Message message;
  final String receiverUid;
  final String conversationId;
  final Uint8List memoryImage;
  final MessageBubbleViewModel messageBubbleModel;
  const ImageMedia({
    Key? key,
    required this.isRead,
    required this.message,
    required this.memoryImage,
    required this.receiverUid,
    required this.conversationId,
    required this.messageBubbleModel,
  }) : super(key: key);

  @override
  State<ImageMedia> createState() => _ImageMediaState();
}

class _ImageMediaState extends State<ImageMedia> {
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
            widget.messageBubbleModel.taskState == TaskState.running
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
    var hiveBox = Hive.box(HiveHelper.hiveBoxImages);

    return ViewModelBuilder<ImageViewModel>.reactive(
      viewModelBuilder: () => ImageViewModel(),
      onModelReady: (model) async {
        // final hivePod = context.read(imageViewModelProvider);

        // bool containPath = hivePod.contains(widget.message.messageUid);
        // if (!containPath) {
        //   log.wtf(
        //       'Hive not contain this path Uid: ${widget.message.messageUid}');
        //   await model.uploadAndSave(
        //     model: widget.messageBubbleModel,
        //     messageUid: widget.message.messageUid,
        //     conversationId: widget.conversationId,
        //     filePath: widget.message.message[MessageField.mediaURL],
        //   );
        // } else {
        //   log.wtf('Hive Contain this Path Uid: ${widget.message.messageUid}');
        // }
      },
      builder: (context, model, child) {
        return ValueListenableBuilder<Box<dynamic>>(
          valueListenable: Hive.box(HiveHelper.hiveBoxImages).listenable(),
          builder: (context, box, child) {
            bool containPath = box.containsKey(widget.message.messageUid);
            return Stack(
              alignment: Alignment.center,
              children: [
                mediaBubble(
                  context: context,
                  isRead: widget.isRead,
                  child: !containPath
                      ? ExtendedImage(image: MemoryImage(widget.memoryImage))
                      : ExtendedImage.file(
                          File(hiveBox.get(widget.message.messageUid))),
                ),
                !containPath
                    ? widget.messageBubbleModel.isuploading
                        ? uploadingProgress(widget.messageBubbleModel)
                        : !widget.message.message[MessageField.uploaded]
                            ? retryButton()
                            : const SizedBox.shrink()
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
