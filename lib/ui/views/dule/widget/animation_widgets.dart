import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/animations/light_clipper.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:lottie/lottie.dart';

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

Widget lottieAnimation(
    BuildContext context, AnimationController balloonsController) {
  const balloonsAnimationUrl =
      'https://assets3.lottiefiles.com/datafiles/6noNCcKTHSPTR58PUjeZyBEISORjlZceiZznmp02/balloons_animation.json';
  return Lottie.network(
    balloonsAnimationUrl,
    width: screenWidth(context),
    controller: balloonsController,
    height: MediaQuery.of(context).size.height * 0.8,
  );
}

Widget confettiAnimation(
  BuildContext context,
  ConfettiController confettiController,
  double blastDirection,
) {
  return Positioned(
    bottom: -80,
    left: 0,
    child: ConfettiWidget(
      gravity: 0.2,
      minBlastForce: 300,
      maxBlastForce: 400,
      numberOfParticles: 400,
      blastDirection: blastDirection,
      emissionFrequency: 0.01,
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive,
    ),
  );
}
