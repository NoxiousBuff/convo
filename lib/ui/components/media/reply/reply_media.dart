import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReplyMedia extends StatelessWidget {
  final String? replyMsgId;
  final String? replyType;
  final String? replyUid;
  final String? replyMsg;
  final bool? isReply;
  const ReplyMedia({
    Key? key,
    required this.replyType,
    required this.replyMsg,
    required this.replyMsgId,
    required this.isReply,
    required this.replyUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isReply ?? false
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  replyMsg!,
                  style: GoogleFonts.roboto(
                    fontSize: 15.0,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
