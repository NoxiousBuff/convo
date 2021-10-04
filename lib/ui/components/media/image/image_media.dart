import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/hint_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class ImageMedia extends StatefulWidget {
  final bool isMe;
  final String receiverUid;
  final String conversationId;
  final HintMessage hiveMessage;
  final MessageBubbleViewModel model;
  const ImageMedia({
    Key? key,
    required this.isMe,
    required this.model,
    required this.receiverUid,
    required this.hiveMessage,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<ImageMedia> createState() => _ImageMediaState();
}

class _ImageMediaState extends State<ImageMedia> {
  final radius = BorderRadius.circular(16);

  Future<void> uploadAndSave() async {
    final message = widget.hiveMessage;
    final downloadUrl = await widget.model
        .uploadFile(
            messageUid: widget.hiveMessage.messageUid,
            filePath: widget.hiveMessage.mediaPaths)
        .whenComplete(() {
      getLogger('ImageMedia').wtf('Image uploaded succesfully !!');
    });
    await chatService.addFirestoreMessage(
        type: message.messageType,
        messageUid: message.messageUid,
        receiverUid: widget.receiverUid,
        timestamp: Timestamp.now(),
        mediaUrls: downloadUrl,
        mediaUrlsType: message.messageType);
  }

  @override
  void initState() {
    super.initState();
    final hiveBox = Hive.box("ChatRoomMedia[${widget.conversationId}]");
    bool hiveContain = hiveBox.containsKey(widget.hiveMessage.messageUid);
    if (!hiveContain) {
      uploadAndSave();
    } else {
      getLogger('ImageMedia').wtf('hive contain ImagePath');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  Widget uploadingProgress(MessageBubbleViewModel model) {
    return Positioned(
      bottom: 5,
      left: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: model.uploadingProgress,
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

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final borderRadius = BorderRadius.circular(12);
    final border = Border.all(color: extraLightBackgroundGray, width: 5);
    final decoration = BoxDecoration(border: border, borderRadius: radius);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: decoration,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            minHeight: MediaQuery.of(context).size.width * 0.2,
            maxHeight: MediaQuery.of(context).size.height * 0.35,
          ),
          child: ClipRRect(
              borderRadius: borderRadius,
              child: Image.file(File(widget.hiveMessage.mediaPaths))),
        ),
        model.busy(model.isuploading)
            ? uploadingProgress(model)
            : const SizedBox.shrink()
      ],
    );
  }
}
