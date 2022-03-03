import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat/chat_media/image_media.dart';
import 'package:hint/ui/views/chat/chat_media/text_media.dart';
import 'package:hint/ui/views/chat/chat_media/videothumbnail_widget.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool fromReceiver;
  const MessageBubble(
      {Key? key, required this.message, required this.fromReceiver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget deliveredText(Message message) {
      final date = message.timestamp.toDate();
      final time = DateFormat('hh:mm a').format(date);

      return message.isRead
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Delivered', style: TextStyle(fontSize: 10)),
                verticalSpaceTiny,
                Text(time, style: const TextStyle(fontSize: 10))
              ],
            )
          : shrinkBox;
    }

    Widget messageBubble() {
      switch (message.type) {
        case MediaType.text:
          return TextMedia(fromReceiver: fromReceiver, message: message);
        case MediaType.image:
          return ImageMedia(
              imageURL: message.message[MessageField.mediaUrl],
              messageUid: message.messageUid);
        case MediaType.video:
          {
            return VideoThumbnailWidget(
                imageURL: message.message[MessageField.mediaUrl],
                messageUid: message.messageUid);
          }
        default:
          return shrinkBox;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        mainAxisAlignment:
            fromReceiver ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment:
            fromReceiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          messageBubble(),
          verticalSpaceTiny,
          deliveredText(message),
        ],
      ),
    );
  }
}
