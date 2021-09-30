import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/hint_message.dart';
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
    hiveContainPath =
        Hive.box("ChatRoomMedia[$conversationId]").containsKey(messageUid);
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
                child: Column(
                children: [
                  CircularProgressIndicator(
                    value: model.uploadingProgress,
                    backgroundColor: Colors.transparent,
                  ),
                  Text("${model.uploadingProgress!.toInt()}%",
                      style: GoogleFonts.roboto(
                          fontSize: 25.0, color: systemBackground)),
                ],
              ))
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

  Widget senderImage() {
    final messageUid = widget.hiveMessage.messageUid;
    final imagePath = widget.hiveMessage.mediaPaths;
    return imagePath != null
        ? Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.width * 0.2,
                    minWidth: MediaQuery.of(context).size.width * 0.2,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ExtendedImage(
                    image: FileImage(File(imagePath)),
                  ),
                ),
              ),
              retryButton(
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
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget receiverImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ExtendedImage(
            filterQuality: FilterQuality.low,
            image: FileImage(File("widget.firestoreImage!")),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: systemBackground),
          ),
          child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.download),
                ),
                Text(
                  'Download',
                  style: TextStyle(color: systemBackground),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.width * 0.2,
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: senderImage(),
        // HintImage(
        //     onTap: () {},
        //     uuid: widget.messageUid,
        //     folderPath: 'Hint Images',
        //     mediaUrl: widget.mediaUrl,
        //     hiveBoxName: HiveHelper.hiveBoxImages,
        //     conversationId: widget.conversationId,
        //   ),
      ),
    );
  }
}
