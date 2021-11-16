import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_background/animated_background.dart';

class SpotLight extends StatefulWidget {
  const SpotLight({Key? key}) : super(key: key);

  @override
  _SpotLightState createState() => _SpotLightState();
}

class _SpotLightState extends State<SpotLight> with TickerProviderStateMixin {
  AnimationController? controller;
  CurveTween curveTween =
      CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.ease));
  CurveTween curveTween2 =
      CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.ease));
  double x = 100, y = 100;
  final radius = 0.0;
  bool lightOn = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000));

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
    controller!.repeat();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  /// Radius of Spotlight
  Animation<double> _radius() {
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: 5.0, end: 0.5).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: 0.5, end: 5.0).chain(curveTween2), weight: 50)
      ],
    ).animate(controller!);
  }

  ///  particles container height
  Animation<double> height() {
    final size = MediaQuery.of(context).size;
    double begin = size.height * 0.0;
    double end = size.height * 0.8;
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: begin, end: end).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: end, end: begin).chain(curveTween2),
            weight: 50),
      ],
    ).animate(controller!);
  }

  ///  Particles Container Width
  Animation<double> width() {
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 200.0).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: 200.0, end: 0.0).chain(curveTween2),
            weight: 50),
      ],
    ).animate(controller!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    setState(() {
      lightOn = true;
      x = size.width * 0.785;
      y = size.height * 0.710;
    });
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipPath(
              clipper: LightClipper(x, y, radius: radius),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: _radius().value,
                    center: const Alignment(0.8, 0.7),
                    colors: [
                      transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              right: size.width * -0.2,
              child: Transform.rotate(
                angle: 0.349066,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1.0,
                            center: const Alignment(0.8, 0.6),
                            colors: [
                              Colors.white60.withOpacity(0),
                              Colors.black45.withOpacity(0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100)),
                      height: height().value,
                      width: width().value,
                      child: AnimatedBackground(
                        child: const SizedBox.shrink(),
                        vsync: this,
                        behaviour: RandomParticleBehaviour(
                          options: const ParticleOptions(
                            baseColor: Colors.white60,
                            particleCount: 200,
                            spawnMaxRadius: 1.0,
                            spawnMinRadius: 1.0,
                            spawnMaxSpeed: 20.0,
                            spawnMinSpeed: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.8,
              right: size.width * 0.04,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (_, watch, __) {
                      return GestureDetector(
                        onTap: () {},
                        child: Text('Hint Message',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: activeBlue)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LightClipper extends CustomClipper<Path> {
  final double x, y;
  final double radius;
  LightClipper(this.x, this.y, {this.radius = 50.0});

  @override
  Path getClip(Size size) {
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    return Path.combine(PathOperation.reverseDifference, circlePath, fullPath);
  }

  @override
  bool shouldReclip(LightClipper oldClipper) =>
      x != oldClipper.x || y != oldClipper.y;
}