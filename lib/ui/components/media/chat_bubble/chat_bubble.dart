import 'package:flutter/material.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble_type.dart';
import 'package:hint/ui/components/media/chat_bubble/clipper.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;
  final double radius;
  final double nipSize;
  final Color bubbleColor;
  final BubbleType bubbleType;

  const ChatBubble({
    Key? key,
    this.radius = 18,
    this.nipSize = 10,
    required this.child,
    required this.bubbleType,
    required this.bubbleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      color: bubbleColor,
      clipper:
          ChatBubbleClipper(type: bubbleType, nipSize: nipSize, radius: radius),
      child: Padding(
        padding: setPadding(),
        child: child,
      ),
    );
  }

  EdgeInsets setPadding() {
    if (bubbleType == BubbleType.sendBubble) {
      return const EdgeInsets.only(right: 12);
    } else {
      return const EdgeInsets.only(left: 12);
    }
  }
}
