import 'package:flutter/material.dart';

class BalloonWidget extends StatefulWidget {
  final Animation<Offset> position;
  final Animation<double> animation;
  const BalloonWidget({Key? key, required this.animation, required this.position}) : super(key: key);

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (_, child) {
        return SlideTransition(
          position: widget.position,
          child: Image.asset(
            'images/red_balloon.png',
            width: widget.animation.value,
            height: widget.animation.value,
          ),
        );
      },
    );
  }
}
