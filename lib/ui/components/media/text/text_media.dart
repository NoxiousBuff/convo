import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

//todo active message colour was Color.fromRGBO(100,132,255,1) and inactive colour was Colors.grey.shade700
// light lilac color : Color(0x14350bdf)

class TextMedia extends StatelessWidget {
  final bool isMe;
  final String? messageText;
  final String conversationId;
  const TextMedia(
      {Key? key,
      required this.isMe,
      required this.messageText,
      required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: isMe ? const Color(0x14350bdf) : CupertinoColors.systemGrey6,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          minWidth: MediaQuery.of(context).size.width * 0.1),
      child: messageText != null
          ? Text(
              messageText!,
              style: GoogleFonts.roboto(
                fontSize: 14.0,
                color: isMe ? CupertinoColors.black : Colors.black,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
