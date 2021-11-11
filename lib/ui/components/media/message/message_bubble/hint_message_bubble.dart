import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/components/media/text/text_media.dart';

class HintMessageBubble extends StatefulWidget {
  final Message message;
  final int messageIndex;
  final String conversationId;
  const HintMessageBubble(
      {Key? key,
      required this.message,
      required this.messageIndex,
      required this.conversationId})
      : super(key: key);

  @override
  _HintMessageBubbleState createState() => _HintMessageBubbleState();
}

class _HintMessageBubbleState extends State<HintMessageBubble> {
  final log = getLogger('HintMessageBubble');

  @override
  void initState() {
    log.wtf('Message:${widget.message.message[MessageField.messageText]}');
    log.wtf('Index:${widget.messageIndex} | Uid:${widget.message.messageUid}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isRead = widget.message.isRead;
    bool isMe = FirestoreApi.liveUserUid == widget.message.senderUid;
    final mainAxis = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: mainAxis,
        crossAxisAlignment: crossAxis,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextMedia(
            isMe: isMe,
            isRead: isRead,
            conversationId: widget.conversationId,
            messageText: widget.message.message[MessageField.messageText],
          ),
        ],
      ),
    );
  }
}
