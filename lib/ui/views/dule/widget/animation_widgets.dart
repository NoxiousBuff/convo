import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/animations/light_clipper.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

Widget lightClipperAnimation(BuildContext context) {
  const radius = 0.0;
  double x = 100, y = 100;
  return ClipPath(
    clipper: LightClipper(x, y, radius: radius),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.5,
          center: const Alignment(0.0, -0.3),
          colors: [
            Theme.of(context).colorScheme.white,
            Theme.of(context).colorScheme.black,
          ],
        ),
      ),
    ),
  );
}

Widget balloonsLottieAnimation(
    BuildContext context, AnimationController balloonsController) {
  return Lottie.asset(
    'assets/animation.json',
    width: screenWidth(context),
    controller: balloonsController,
    height: MediaQuery.of(context).size.height,
  );
}

Widget heartsLottieAnimation(
    BuildContext context, AnimationController heatsController) {
  return Lottie.asset(
    'assets/hearts.json',
    width: screenWidth(context),
    controller: heatsController,
    height: MediaQuery.of(context).size.height,
  );
}

Widget confettiAnimation(BuildContext context,
    ConfettiController confettiController, double blastDirection,
    {bool isLeft = false}) {
  return Positioned(
    bottom: -80,
    left: isLeft ? 0 : null,
    right: isLeft ? null : 0,
    child: ConfettiWidget(
      gravity: 0.2,
      minBlastForce: 300,
      maxBlastForce: 400,
      numberOfParticles: 400,
      emissionFrequency: 0.01,
      blastDirection: blastDirection,
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive,
    ),
  );
}