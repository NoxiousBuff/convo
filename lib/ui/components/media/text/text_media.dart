import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble_type.dart';

//todo active message colour was Color.fromRGBO(100,132,255,1) and inactive colour was Colors.grey.shade700
// light lilac color : Color(0x14350bdf)

class TextMedia extends StatelessWidget {
  final bool isMe;
  final bool isRead;
  final String? messageText;
  final String conversationId;
  const TextMedia(
      {Key? key,
      required this.isMe,
      required this.isRead,
      required this.messageText,
      required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messageText != null) {
      int length = messageText!.length;
      return ChatBubble(
        radius: length > 3 ? 20 : 20,
        bubbleType: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble,
        bubbleColor: isMe
            ? isRead
                ? activeBlue
                : lightBlue
            : CupertinoColors.systemGrey6,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              minWidth: MediaQuery.of(context).size.width * 0.1),
          child: Text(
            messageText!,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: systemBackground),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
