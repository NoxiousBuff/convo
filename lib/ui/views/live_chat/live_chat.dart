import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/livechat_model.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:string_validator/string_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class DuleView extends StatefulWidget {
  const DuleView({Key? key, required this.fireUser}) : super(key: key);

  static const String id = '/DuleView';

  final FireUser fireUser;

  @override
  State<DuleView> createState() => _DuleViewState();
}

class _DuleViewState extends State<DuleView> with TickerProviderStateMixin {
  final log = getLogger('DuleView');
  final radius = 0.0;
  bool lightOn = true;
  double x = 100, y = 100;
  bool incongonatedMode = false;
  late ConfettiController confettiController;
  late AnimationController balloonsController;
  late AnimationController spotlightController;

  @override
  void initState() {
    balloonsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    spotlightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    spotlightController.addListener(() => setState(() {}));
    confettiController.addListener(() => setState(() {}));
    balloonsController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    spotlightController.removeListener(() {});
    balloonsController.removeListener(() {});
    confettiController.dispose();
    spotlightController.dispose();
    balloonsController.dispose();
    super.dispose();
  }

  Widget receiverMessageBubble(Event? data, DuleViewModel model) {
    if (data == null) {
      return const Center(
        child: Text('Connecting...'),
      );
    } else {
      final snapshot = data.snapshot;
      final json = snapshot.value.cast<String, dynamic>();
      final duleModel = DuleModel.fromJson(json);

      switch (duleModel.online) {
        case true:
          {
            if (model.conversationId == duleModel.roomUid) {
              model.updateOtherField(duleModel.msgTxt);
              if (duleModel.urlType == 'image' && isURL(duleModel.msgTxt)) {
                return Image.network(duleModel.url);
              } else {
                return TextFormField(
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  readOnly: true,
                  cursorHeight: 28,
                  controller: model.otherTech,
                  cursorColor: AppColors.blue,
                  textAlign: TextAlign.center,
                  cursorRadius: const Radius.circular(100),
                  onChanged: (value) => model.updatTextFieldWidth(),
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                  decoration: const InputDecoration(
                    hintText: 'Message Received',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 24),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'User Is Busy',
                  style: TextStyle(color: Colors.black38, fontSize: 24),
                ),
              );
            }
          }
        case false:
          {
            return const Center(
              child: Text(
                'User is offline.',
                style: TextStyle(color: Colors.black38, fontSize: 24),
              ),
            );
          }
        default:
          {
            return const SizedBox.shrink();
          }
      }
    }
  }

  Widget animationWidget(Event? data) {
    if (data == null) {
      return const SizedBox.shrink();
    } else {
      final snapshot = data.snapshot;
      final json = snapshot.value.cast<String, dynamic>();
      final duleModel = DuleModel.fromJson(json);

      switch (duleModel.aniType) {
        case AnimationType.balloons:
          {
            return Lottie.network(
              'https://assets3.lottiefiles.com/datafiles/6noNCcKTHSPTR58PUjeZyBEISORjlZceiZznmp02/balloons_animation.json',
              animate: true,
              width: screenWidth(context),
              height: screenHeight(context),
              fit: BoxFit.cover,
              controller: balloonsController,
              onLoaded: (composition) {
                balloonsController
                  ..duration = const Duration(seconds: 5)
                  ..forward();
              },
            );
          }
        case AnimationType.confetti:
          {
            return Positioned(
              bottom: -80,
              left: screenHeightPercentage(context, percentage: 0.3),
              child: ConfettiWidget(
                gravity: 0.3,
                minBlastForce: 100,
                maxBlastForce: 400,
                numberOfParticles: 200,
                blastDirection: -pi / 2,
                emissionFrequency: 0.04,
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            );
          }
        default:
          {
            return const SizedBox.shrink();
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    setState(() {
      x = size.width * 0.785;
      y = size.height * 0.710;
    });
    final decoration = BoxDecoration(
        color: incongonatedMode ? transparent : AppColors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32));
    const systemUIOverlay =
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark);
    return ViewModelBuilder<DuleViewModel>.reactive(
      onModelReady: (model) => model.createGetConversationId(),
      viewModelBuilder: () => DuleViewModel(widget.fireUser),
      builder: (context, model, child) {
        final data = model.data;

        if (model.hasError) {
          return const Center(
            child: Text('Model has Error'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 100,
            centerTitle: true,
            backgroundColor: incongonatedMode ? black : transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle: systemUIOverlay,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(8),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: incongonatedMode ? systemBackground : black,
                  onPressed: () => Navigator.pop(context),
                ),
                horizontalDefaultMessageSpace,
                ClipOval(
                  child: Image.network(
                    widget.fireUser.photoUrl!,
                    cacheHeight: 48,
                    cacheWidth: 48,
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            title: Text(
              widget.fireUser.username,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 18, color: black),
            ),
            actions: [
              CupertinoSwitch(
                value: incongonatedMode,
                onChanged: (val) {
                  setState(() {
                    incongonatedMode = val;
                  });
                },
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ClipPath(
                clipper: LightClipper(x, y, radius: radius),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: incongonatedMode ? 0.5 : 5,
                      center: const Alignment(0.1, -0.6),
                      colors: const [
                        systemBackground,
                        black,
                      ],
                    ),
                  ),
                ),
              ),
              Lottie.network(
                'https://assets3.lottiefiles.com/datafiles/6noNCcKTHSPTR58PUjeZyBEISORjlZceiZznmp02/balloons_animation.json',
                width: screenWidth(context),
                height: screenHeightPercentage(context, percentage: 0.8),
                fit: BoxFit.cover,
                controller: balloonsController,
                onLoaded: (composition) {
                  // balloonsController
                  //   ..duration = const Duration(seconds: 5)
                  //   ..forward();
                },
              ),
              Column(
                children: [
                  verticalSpaceSmall,
                  Expanded(
                    flex: model.otherFlexFactor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: decoration,
                        alignment: Alignment.center,
                        child: receiverMessageBubble(data, model),
                        width: screenWidthPercentage(context, percentage: 80),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  Expanded(
                    flex: model.duleFlexFactor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(0),
                        duration: const Duration(milliseconds: 200),
                        width: screenWidthPercentage(context, percentage: 80),
                        alignment: Alignment.center,
                        child: TextFormField(
                          focusNode: model.duleFocusNode,
                          minLines: null,
                          maxLines: null,
                          expands: true,
                          onChanged: (value) {
                            model.updateWordLengthLeft(value);
                            model.updatTextFieldWidth();
                            model.updateUserDataWithKey(
                                DatabaseMessageField.msgTxt, value);
                          },
                          maxLength: 160,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          buildCounter: (_,
                              {required currentLength,
                              maxLength,
                              required isFocused}) {
                            return const SizedBox.shrink();
                          },
                          controller: model.duleTech,
                          cursorColor: Colors.white,
                          cursorHeight: 28,
                          cursorRadius: const Radius.circular(100),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: 'Type your message',
                              hintStyle: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 24),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        decoration: BoxDecoration(
                            color: incongonatedMode
                                ? transparent
                                : AppColors.blue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        horizontalSpaceRegular,
                        IconButton(
                          onPressed: () => model.updateDuleFocus(),
                          icon: const Icon((CupertinoIcons.keyboard)),
                          color: model.duleFocusNode.hasFocus
                              ? AppColors.blue
                              : inactiveGray,
                          iconSize: 32,
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: transparent,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
                                            var value = AnimationType.confetti;
                                            await model.updateAnimation(value);
                                            confettiController.play();
                                            await model.updateAnimation(null);
                                          },
                                          child: const Chip(
                                              label: Text('Confetti'))),
                                      const SizedBox(width: 10),
                                      const Chip(label: Text('Spotlight')),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          var value = AnimationType.balloons;
                                          await model.updateAnimation(value);
                                          balloonsController.forward();
                                          await model.updateAnimation(null);
                                        },
                                        child: const Chip(
                                          label: Text('Balloons'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon((Icons.animation)),
                          color: inactiveGray,
                          iconSize: 32,
                        ),
                        IconButton(
                          onPressed: () => model.pickImage(context),
                          icon: const Icon((CupertinoIcons.camera)),
                          color: inactiveGray,
                          iconSize: 32,
                        ),
                        IconButton(
                          onPressed: () => model.pickFromGallery(context),
                          icon: const Icon((Icons.photo_library_outlined)),
                          color: inactiveGray,
                          iconSize: 32,
                        ),
                        const Spacer(),
                        Text(
                          model.wordLengthLeft,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                          onPressed: () {
                            model.clearMessage();
                          },
                          icon: const Icon((Icons.restart_alt)),
                          color:
                              model.isDuleEmpty ? inactiveGray : AppColors.red,
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              Positioned(
                bottom: -80,
                left: 0,
                child: ConfettiWidget(
                  gravity: 0.2,
                  minBlastForce: 300,
                  maxBlastForce: 400,
                  numberOfParticles: 500,
                  blastDirection: -pi,
                  emissionFrequency: 0.01,
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
              Positioned(
                bottom: -80,
                right: 0,
                child: ConfettiWidget(
                  gravity: 0.2,
                  minBlastForce: 300,
                  maxBlastForce: 400,
                  numberOfParticles: 500,
                  blastDirection: pi,
                  emissionFrequency: 0.01,
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
            ],
          ),
        );
      },
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
