import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';

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
      required this.conversationId,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messageText != null) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.05,),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? LightAppColors.primary : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(20)),
        child: RichText(
          text: TextSpan(
            text: messageText,
            style: const TextStyle(color: LightAppColors.onPrimary),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
