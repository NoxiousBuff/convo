import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/components/media/message/reply_message.dart';
class ReplyKeyboardMedia extends StatelessWidget {
  final String? replyMsgId;
  final String? replyType;
  final String? replyUid;
  final String? replyMsg;
  final bool? isReply;
  final String? replyMediaUrl;
  const ReplyKeyboardMedia({
    Key? key,
    required this.replyType,
    required this.replyMsg,
    required this.replyMsgId,
    required this.isReply,
    required this.replyUid,
    required this.replyMediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return isReply ?? false
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const IconButton(onPressed: null, icon: Icon(Icons.ios_share)),
                Expanded(
                  child: Container(
                    child: Text(
                      replyMsg!.replaceAll('\n', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        minWidth: MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    getLogger('Reply Keyboard Media').wtf('IconButton is pressed');
                    context.read(replyPod).emptyReplyFields();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
