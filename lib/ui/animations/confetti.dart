import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class Confetti extends StatefulWidget {
  const Confetti({Key? key}) : super(key: key);

  @override
  _ConfettiState createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late ConfettiController confettiController;

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    confettiController.addListener(() {
      if (confettiController.state == ConfettiControllerState.stopped) {
        confettiController.play();
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      confettiController.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: screenHeight(context),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        'Receiver Message',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        'Sender Message',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -200,
            left: 200,
            child: ConfettiWidget(
              gravity: 1.0,
              shouldLoop: false,
              minBlastForce: 10,
              maxBlastForce: 20,
              particleDrag: 0.05,
              displayTarget: true,
              numberOfParticles: 1,
              blastDirection: pi / 2,
              emissionFrequency: 0.6,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
        ],
      ),
    );
  }
}