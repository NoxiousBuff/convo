import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/hint_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Widget retryButton({required void Function()? onPressed}) {
    final model = widget.model;
    final messageUid = widget.hiveMessage.messageUid;
    bool isFileUploading = model.uploadingMessageUid == messageUid;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: isFileUploading
            ? Center(
                child: Text("${model.uploadingProgress.toInt()}%",
                    style: GoogleFonts.roboto(
                        fontSize: 25.0, color: systemBackground)),
              )
            : TextButton(
                onPressed: onPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.upload, color: extraLightBackgroundGray),
                    SizedBox(width: 10),
                    Text(
                      'Retry',
                      style: TextStyle(color: systemBackground, fontSize: 15),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget imageWidget({required Widget child}) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
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
        child: ExtendedImage(
          filterQuality: FilterQuality.low,
          image: FileImage(File(widget.hiveMessage.mediaPaths)),
        ),
      );
    } else {
      return imageWidget(
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageWidget(
              child: ExtendedImage(
                image: FileImage(
                  File(imagePath),
                ),
              ),
            ),
            !hiveContainPath
                ? retryButton(
                    onPressed: () async {
                      final url = await widget.model.uploadFile(
                        filePath: imagePath,
                        messageUid: messageUid,
                      );
                      await chatService.addFirestoreMessage(
                        type: imageType,
                        messageText: url,
                        messageUid: messageUid,
                        timestamp: Timestamp.now(),
                        receiverUid: widget.receiverUid,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }
}
