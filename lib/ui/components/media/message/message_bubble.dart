import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/components/media/image/image_media.dart';
import 'package:hint/ui/components/media/reply/reply_media.dart';
import 'package:hint/ui/components/media/text/text_media.dart';
import 'package:hint/ui/components/media/video/video_media.dart';

class MessageBubble extends StatelessWidget {
  final BuildContext? context;
  final Message messageData;
  const MessageBubble({Key? key, this.context, required this.messageData})
      : super(key: key);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;

  Widget mediaContent(String? type, bool isMe) {
    switch (type) {
      case 'image':
        {
          return ImageMedia(
            isMe: isMe,
            mediaUrl: messageData.mediaUrl,
            messageText: messageData.messageText,
            messageUid: messageData.messageUid,
            timestamp: messageData.timestamp,
          );
        }
      //todo: to figure out what does this break statement do in null safety and why is it dead code
      // break;
      case 'video':
        {
          return VideoMedia(
            messageUid: messageData.messageUid,
            mediaUrl: messageData.mediaUrl ?? '',
            messageText: messageData.messageText,
            timestamp: messageData.timestamp,
            isMe: isMe,
          );
        }
      // break;
      default:
        {
          return SizedBox.shrink();
        }
      // break;
    }
  }

  Widget messageBubble(BuildContext context) {
    bool isMe = liveUserUid == messageData.senderUid;
    // final replyProvider = Provider.of<ReplyProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            messageData.isReply
                ? SizedBox(height: 10)
                : SizedBox(height: 0.5),
            ReplyMedia(
                replyType: messageData.replyType,
                replyMsg: messageData.replyMsg,
                replyMsgId: messageData.replyMsgId,
                isReply: messageData.isReply,
                replyUid: messageData.replyUid),
            mediaContent(messageData.type, isMe),
            SizedBox(height: 0.5),
            TextMedia(
              messageText: messageData.messageText,
              isMe: isMe,
            ),
            SizedBox(height: 0.5),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return messageBubble(context);
  }
}
