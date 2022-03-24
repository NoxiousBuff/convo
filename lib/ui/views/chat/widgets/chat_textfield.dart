import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

/// This is the UI of a textfield in a cht room
class ChatTextField extends StatefulWidget {
  final Widget child;
  const ChatTextField({Key? key, required this.child}) : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.9),
                minWidth: screenWidthPercentage(context, percentage: 0.01)),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.lightGrey,
                borderRadius: BorderRadius.circular(32)),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
