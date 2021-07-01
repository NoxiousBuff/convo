import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BalloonsAnimation extends StatefulWidget {
  @override
  _BalloonsAnimationState createState() => _BalloonsAnimationState();
}

class _BalloonsAnimationState extends State<BalloonsAnimation>
    with TickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Center(
              child: Lottie.network(
                'https://assets5.lottiefiles.com/datafiles/6noNCcKTHSPTR58PUjeZyBEISORjlZceiZznmp02/balloons_animation.json',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
                controller: controller,
                onLoaded: (composition) {
                  controller!
                    ..duration = Duration(seconds: 5)
                    ..forward()
                    ..repeat();
                  print('animation');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
