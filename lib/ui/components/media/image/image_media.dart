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
import 'package:hint/ui/views/chat/chat_viewmodel.dart';

class ImageMedia extends StatefulWidget {
  final bool isMe;
  final String receiverUid;
  final ChatViewModel model;
  final String conversationId;
  final HintMessage hiveMessage;
  const ImageMedia({
    Key? key,
    required this.isMe,
    required this.model,
    required this.receiverUid,
    required this.hiveMessage,
    required this.conversationId,
  }) : super(key: key);

  @override
  _ImageMediaState createState() => _ImageMediaState();
}

class _ImageMediaState extends State<ImageMedia> {
  bool hiveContainPath = false;
  final borderRadius = BorderRadius.circular(16);
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    final conversationId = widget.conversationId;
    final messageUid = widget.hiveMessage.messageUid;
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    setState(() {
      hiveContainPath = hiveBox.containsKey(messageUid);
    });
    getLogger('ImageMedia').wtf('hiveContainPath:$hiveContainPath');
  }

  Widget retryButton() {
    final model = widget.model;
    final messageUid = widget.hiveMessage.messageUid;
    bool isFileUploading = model.uploadingMessageUid == messageUid;

    return isFileUploading
        ? Positioned(bottom: 5, left: 5, child: uploadingProgress())
        : TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload, color: extraLightBackgroundGray),
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
          );
  }

  Widget imageWidget({required Widget child}) {
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

  Widget uploadingProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: systemBackground,
          value: widget.model.uploadingProgress,
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
    final messageUid = widget.hiveMessage.messageUid;
    final imagePath = widget.hiveMessage.mediaPaths;
    final hiveBox = Hive.box("ChatRoomMedia[${widget.conversationId}]");
    setState(() {
      hiveContainPath = hiveBox.containsKey(messageUid);
    });
    if (hiveContainPath) {
      return imageWidget(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ExtendedImage(
            filterQuality: FilterQuality.low,
            image: FileImage(File(widget.hiveMessage.mediaPaths)),
          ),
        ),
      );
    } else {
      return imageWidget(
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
                    File(imagePath),
                  ),
                ),
              ),
            ),
            !hiveContainPath ? retryButton() : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }
}
