import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/message_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TextMedia extends StatelessWidget {
  final bool fromReceiver;
  final Message message;
  const TextMedia({Key? key, required this.fromReceiver, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: fromReceiver
              ? Theme.of(context).colorScheme.grey
              : message.isRead
                  ? Theme.of(context).colorScheme.blue
                  : Theme.of(context).colorScheme.blue.withAlpha(150),
          borderRadius: BorderRadius.circular(20)),
      child: ParsedText(
        text: message.message[MessageField.messageText],
        style: TextStyle(
            color: fromReceiver
                ? Theme.of(context).colorScheme.black
                : Theme.of(context).colorScheme.white),
        parse: [
          MatchText(
            type: ParsedType.EMAIL,
            style: TextStyle(
              color: Colors.lightBlueAccent.shade100,
            ),
            onTap: (url) => launch(
                "mailto:${message.message[MessageField.messageText]}" + url),
          ),
          MatchText(
              type: ParsedType.PHONE,
              style: TextStyle(
                color: Colors.lightBlueAccent.shade100,
              ),
              onTap: (url) => launch("tel:" + url)),
          MatchText(
              type: ParsedType.URL,
              style: TextStyle(
                color: Colors.lightBlueAccent.shade100,
              ),
              onTap: (url) => launch(url)),
        ],
      ),
    );
  }
}
