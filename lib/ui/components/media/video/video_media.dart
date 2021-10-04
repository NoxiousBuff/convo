import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/hint_message.dart';
import 'package:hint/services/chat_service.dart';

class VideoMedia extends StatefulWidget {
  final bool isMe;
  final String conversationId;
  final HintMessage hiveMessage;
  final Uint8List videoThumbnail;
  final String receiverUid;
  final MessageBubbleViewModel model;
  const VideoMedia({
    Key? key,
    required this.isMe,
    required this.model,
    required this.receiverUid,
    required this.hiveMessage,
    required this.videoThumbnail,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<VideoMedia> createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  final radius = BorderRadius.circular(16);

  Future uploadAndSave() async {
    final message = widget.hiveMessage;
    final downloadUrl = await widget.model
        .uploadFile(
            messageUid: widget.hiveMessage.messageUid,
            filePath: widget.hiveMessage.mediaPaths)
        .whenComplete(() {
      getLogger('VideoMedia').wtf('Video uploaded !!');
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
      getLogger('VideoMedia').wtf('hive contain video path');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            maxHeight: double.infinity,
            minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            minHeight: MediaQuery.of(context).size.width * 0.2,
          ),
          child: ClipRRect(
            borderRadius:borderRadius,
            child: Image.memory(widget.videoThumbnail),
          ),
        ),
        model.busy(model.isuploading)
            ? uploadingProgress(model)
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
  }
}
