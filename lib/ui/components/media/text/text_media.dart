import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//todo active message colour was Color.fromRGBO(100,132,255,1) and inactive colour was Colors.grey.shade700
// light lilac color : Color(0x14350bdf)

class TextMedia extends StatelessWidget {
  final String? messageText;
  final bool isMe;
  const TextMedia({Key? key, required this.messageText, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageText != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: isMe ? Color(0x14350bdf) : CupertinoColors.systemGrey6,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                minWidth: MediaQuery.of(context).size.width * 0.1),
            child: Text(
              messageText!,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: isMe ? CupertinoColors.black : Colors.black,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
