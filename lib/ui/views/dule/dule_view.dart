import 'dart:math';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_validator/string_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/light_clipper.dart';

import 'dule_viewmodel.dart';

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

  @override
  void initState() {
    balloonsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    confettiController.addListener(() => setState(() {}));
    balloonsController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    balloonsController.removeListener(() {});
    confettiController.dispose();
    balloonsController.dispose();
    databaseService.updateUserDataWithKey(DatabaseMessageField.roomUid, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');

    hiveApi.saveInHive(HiveApi.recentChatsHiveBox, widget.fireUser.id, {
      RecentUserField.uid: widget.fireUser.id,
      RecentUserField.timestamp: Timestamp.now().millisecondsSinceEpoch,
    });
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
                  maxLength: 160,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (_,
                      {required currentLength, maxLength, required isFocused}) {
                    return const SizedBox.shrink();
                  },
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    setState(() {
      x = size.width * 0.785;
      y = size.height * 0.710;
    });
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
        return ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
            builder: (context, box, child) {
              const hiveBox = HiveApi.appSettingsBoxName;
              const sKey = AppSettingKeys.senderBubbleColor;
              const rKey = AppSettingKeys.receiverBubbleColor;
              int senderBubbleCode = Hive.box(hiveBox).get(sKey,
                  defaultValue: MaterialColorsCode.blue300);
              int receiverBubbleCode = Hive.box(hiveBox).get(rKey,
                  defaultValue: MaterialColorsCode.lightBlue200);
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  leadingWidth: 100,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: systemUIOverlay,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(FeatherIcons.arrowLeft),
                        color:
                            incongonatedMode ? AppColors.white : Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                      horizontalDefaultMessageSpace,
                      ClipOval(
                        child: Image.network(
                          widget.fireUser.photoUrl,
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
                    widget.fireUser.displayName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 18, color: Colors.black),
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
                    incongonatedMode
                        ? ClipPath(
                            clipper: LightClipper(x, y, radius: radius),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  radius: 0.5,
                                  center: Alignment(0.0, -0.3),
                                  colors: [
                                    AppColors.white,
                                    Colors.black,
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
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
                        topPadding(context),
                        const SizedBox(height: 56),
                        Expanded(
                          flex: model.otherFlexFactor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  color: incongonatedMode
                                      ? Colors.transparent
                                      : Color(receiverBubbleCode),
                                  borderRadius: BorderRadius.circular(32)),
                              alignment: Alignment.center,
                              child: receiverMessageBubble(data, model),
                              width: screenWidthPercentage(context,
                                  percentage: 80),
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
                              width: screenWidthPercentage(context,
                                  percentage: 80),
                              alignment: Alignment.center,
                              child: TextFormField(
                                focusNode: model.duleFocusNode,
                                minLines: null,
                                maxLines: null,
                                expands: true,
                                onChanged: (value) {
                                  model.updateWordLengthLeft(value);
                                  model.updatTextFieldWidth();
                                  if (value.length <= 160) {
                                    model.updateUserDataWithKey(
                                        DatabaseMessageField.msgTxt, value);
                                  }
                                },
                                maxLength: 160,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
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
                                      ? Colors.transparent
                                      : Color(senderBubbleCode),
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
                                icon: const Icon(FeatherIcons.edit3),
                                color: model.duleFocusNode.hasFocus
                                    ? Color(senderBubbleCode)
                                    : AppColors.darkGrey,
                                iconSize: 32,
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 100,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: () async {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Navigator.pop(context);
                                                  var value =
                                                      AnimationType.confetti;
                                                  await model
                                                      .updateAnimation(value);
                                                  confettiController.play();
                                                  await model
                                                      .updateAnimation(null);
                                                },
                                                child: const Chip(
                                                    label: Text('Confetti'))),
                                            const SizedBox(width: 10),
                                            const Chip(
                                                label: Text('Spotlight')),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                var value =
                                                    AnimationType.balloons;
                                                await model
                                                    .updateAnimation(value);
                                                balloonsController.forward();
                                                await model
                                                    .updateAnimation(null);
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
                                icon: const Icon(FeatherIcons.loader),
                                color: AppColors.darkGrey,
                                iconSize: 32,
                              ),
                              IconButton(
                                onPressed: () => model.pickImage(context),
                                icon: const Icon(FeatherIcons.camera),
                                color: AppColors.darkGrey,
                                iconSize: 32,
                              ),
                              IconButton(
                                onPressed: () => model.pickFromGallery(context),
                                icon: const Icon(FeatherIcons.image),
                                color: AppColors.darkGrey,
                                iconSize: 32,
                              ),
                              const Spacer(),
                              Text(
                                model.wordLengthLeft,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: incongonatedMode
                                          ? AppColors.darkGrey
                                          : AppColors.darkGrey,
                                    ),
                              ),
                              IconButton(
                                onPressed: () {
                                  model.clearMessage();
                                },
                                icon: const Icon((FeatherIcons.refreshCcw)),
                                color: model.isDuleEmpty
                                    ? AppColors.darkGrey
                                    : AppColors.red,
                                iconSize: 32,
                              ),
                              horizontalSpaceTiny,
                            ],
                          ),
                        ),
                        bottomPadding(context),
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
            });
      },
    );
  }
}
