import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/livechat_model.dart';
import 'package:hint/api/realtime_database_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({
    Key? key,
  }) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> with TickerProviderStateMixin {
  int textLength = 0;
  double radius = 0.0;
  bool lightOn = true;
  double x = 100, y = 100;
  final log = getLogger('LiveChat');
  late ConfettiController confettiController;
  late AnimationController spotlightController;
  final liveUserUid = FirestoreApi.liveUserUid;
  final database = FirebaseDatabase.instance.reference();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    spotlightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    spotlightController.addListener(() => setState(() {}));
    confettiController.addListener(() => setState(() {}));
    setState(() {
      textLength = (150 - controller.text.length).toInt();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    confettiController.dispose();
    spotlightController.removeListener(() {});
    spotlightController.dispose();
    super.dispose();
  }

  // StreamSubscription<RealtimeMessage> animationHandler() {
  //   return subscription.stream.listen(
  //     (data) {
  //       final receiverUser = LiveChatUser.fromJson(data.payload);
  //       switch (receiverUser.animationType) {
  //         case AnimationType.confetti:
  //           {
  //             log.w('confetti controller :1');
  //             confettiController.play();
  //           }
  //           break;
  //         case AnimationType.spotlight:
  //           {
  //             log.w('spotlight controller :2');
  //             spotlightController.forward();
  //           }
  //           break;
  //         default:
  //           {
  //             log.wtf('User Message is not equal to any animation value');
  //           }
  //       }
  //     },
  //     onError: (e) {
  //       log.e('AppwriteSubscription:$e');
  //     },
  //   );
  // }

  @override
  void didUpdateWidget(covariant LiveChat oldWidget) {
    setState(() {
      lightOn = true;
      x = screenWidthPercentage(context, percentage: 0.785);
      y = screenWidthPercentage(context, percentage: 0.710);
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final valueListenable = ValueNotifier<int>(textLength);
    const valueColor = AlwaysStoppedAnimation(activeGreen);
    const margin = EdgeInsets.fromLTRB(16, 0, 16, 8);
    const constraints = BoxConstraints(minHeight: 30);
    final decoration = BoxDecoration(
        color: extraLightBackgroundGray,
        borderRadius: BorderRadius.circular(16));
    final textStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: inactiveGray, fontSize: 18);
    //var style = Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30);
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: Text(
              'username',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: const [
              // Container(
              //   margin: const EdgeInsets.only(right: 20),
              //   child: const Center(
              //     child: CircleAvatar(
              //       maxRadius: 20,
              //       backgroundImage:
              //           CachedNetworkImageProvider('widget.fireUser.photoUrl!'),
              //     ),
              //   ),
              // ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Flexible(
                      child: StreamBuilder<Event>(
                          stream: realtimeDBApi.documentStream(liveUserUid),
                          builder: (context, snapshot) {
                            final data = snapshot.data;
                            if (snapshot.hasError) const Text('There is error');
                            if (data != null) {
                              final modelData = data.snapshot.value;
                              final map = modelData.cast<String, dynamic>();
                              log.wtf('Value:$map');
                              final doc = LiveChatModel.fromJson(map);
                              final message = doc.userMessage;
                              const m = EdgeInsets.only(right: 20, top: 6);
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin: margin,
                                    decoration: decoration,
                                    constraints: constraints,
                                    width: screenWidth(context),
                                    child: Center(
                                      child: message != null
                                          ? Text(message)
                                          : const Text('Hint Message'),
                                    ),
                                  ),
                                  Container(
                                    margin: m,
                                    child: const CircleAvatar(
                                      backgroundColor: activeGreen,
                                      maxRadius: 10,
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const Text('Data is null now !!');
                            }
                          }),
                    ),
                    Flexible(
                      child: Container(
                        width: screenWidth(context),
                        constraints: const BoxConstraints(minHeight: 30),
                        decoration: BoxDecoration(
                            color: activeBlue,
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Center(
                          child: CupertinoTextField(
                            maxLength: 150,
                            autofocus: true,
                            showCursor: false,
                            textAlign: TextAlign.center,
                            maxLines: controller.text.length > 100 ? 6 : 2,
                            cursorColor: systemBackground,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              color: systemBackground,
                            ),
                            controller: controller,
                            onChanged: (val) {
                              setState(() {
                                textLength = (150 - val.length).toInt();
                              });
                              realtimeDBApi.updateUserDocument(
                                liveUserUid,
                                {
                                  LiveChatField.userMessage: val,
                                },
                              );
                            },
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpaceTiny,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KeyboardVisibilityBuilder(
                                  builder: (context, child, visible) {
                                return IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    CupertinoIcons.keyboard,
                                    color: visible ? activeBlue : inactiveGray,
                                  ),
                                );
                              }),
                              IconButton(
                                onPressed: () {
                                  model.cameraOptions(
                                    context: context,
                                    takePicture: () async {
                                      await model.pickImage(context);
                                    },
                                    recordVideo: () async {
                                      await model.pickVideo(context);
                                    },
                                  );
                                },
                                icon: const Icon(CupertinoIcons.camera),
                              ),
                              model.isBusy
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: model.state == TaskState.running
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: valueColor,
                                              backgroundColor: activeBlue,
                                              value: model.uploadingProgress,
                                            )
                                          : const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: valueColor,
                                              backgroundColor: activeBlue,
                                            ),
                                    )
                                  : IconButton(
                                      icon: const Icon(CupertinoIcons.photo),
                                      onPressed: () async {
                                        await model.pickFromGallery(context);
                                      },
                                    ),
                              IconButton(
                                icon: const Icon(CupertinoIcons.wand_stars),
                                onPressed: () {},
                              ),
                              const Spacer(),
                              ValueListenableBuilder<int>(
                                valueListenable: valueListenable,
                                builder: (_, value, __) {
                                  return Text(value.toString(),
                                      style: textStyle);
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.clear();
                                  setState(() {
                                    textLength = 150;
                                  });
                                  realtimeDBApi.updateUserDocument(
                                    liveUserUid,
                                    {
                                      LiveChatField.userMessage: null,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.restart_alt_rounded),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              spotlightController.status == AnimationStatus.forward
                  ? ClipPath(
                      clipper: LightClipper(x, y, radius: radius),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: model
                                .spotLightRadius(spotlightController)
                                .value,
                            center: const Alignment(0, -0.4),
                            colors: [
                              transparent,
                              black.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
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
                  minimumSize: const Size(20, 20),
                  maximumSize: const Size(30, 30),
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

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible =
      WidgetsBinding.instance!.window.viewInsets.bottom > 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
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
