import 'dart:async';
import 'dart:math';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/database_service.dart';
import 'dule_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/message_string.dart';
import 'package:firebase_database/firebase_database.dart';

class DuleView extends StatefulWidget {
  const DuleView({Key? key, required this.fireUser}) : super(key: key);

  static const String id = '/DuleView';

  final FireUser fireUser;

  @override
  State<DuleView> createState() => _DuleViewState();
}

class _DuleViewState extends State<DuleView> with TickerProviderStateMixin {
  final log = getLogger('DuleView');
  late ConfettiController confettiController;
  late AnimationController spotlightController;

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    spotlightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    spotlightController.addListener(() => setState(() {}));
    confettiController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    spotlightController.removeListener(() {});
    spotlightController.dispose();

    super.dispose();
  }

  StreamSubscription<Event> animationHandler() {
    return databaseService.getUserData(widget.fireUser.id).listen(
      (data) {
        final mapData = data.snapshot.value;
        final userDocMap = mapData.cast<String, dynamic>();
        final receiverUser = DuleModel.fromJson(userDocMap);
        switch (receiverUser.aniType) {
          case AnimationType.confetti:
            {
              log.w('confetti controller :1');
              confettiController.play();
              databaseService.updateUserDataWithKey(
                  DatabaseMessageField.aniType, null);
            }

            break;
          case AnimationType.spotlight:
            {
              log.w('spotlight controller :2');
              spotlightController.forward();
              databaseService.updateUserDataWithKey(
                  DatabaseMessageField.aniType, null);
            }
            break;
          default:
            {
              log.wtf('User Message is not equal to any animation value');
            }
        }
      },
      onError: (e) {
        log.e('StreamSubscription For Animation Error:$e');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    animationHandler();
    return ViewModelBuilder<DuleViewModel>.reactive(
      onModelReady: (model) {
        model.createGetConversationId();
      },
      viewModelBuilder: () => DuleViewModel(widget.fireUser),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          flexibleSpace: InkWell(onTap: () {}),
          leadingWidth: 90,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                horizontalSpaceRegular,
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                horizontalDefaultMessageSpace,
                Expanded(
                  child: ClipOval(
                    child: Image.network(
                      widget.fireUser.photoUrl!,
                      cacheHeight: 48,
                      cacheWidth: 48,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          title: Text(
            widget.fireUser.username,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(children: [
              verticalSpaceSmall,
              Expanded(
                flex: model.otherFlexFactor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(32)),
                    width: screenWidthPercentage(context, percentage: 80),
                    alignment: Alignment.center,
                    child: StreamBuilder<Event>(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child('dules')
                          .child(widget.fireUser.id)
                          .onValue,
                      builder: (context, snapshot) {
                        Widget child;
                        if (!snapshot.hasData) {
                          child = const Center(
                            child: Text(
                              'Connecting.......',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 24),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          child = const Center(
                            child: Text(
                              'We are having problem connecting with the user.',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 24),
                            ),
                          );
                        }
                        final dataSnapshot = snapshot.data!.snapshot;
                        final json = dataSnapshot.value.cast<String, dynamic>();
                        final DuleModel duleModel = DuleModel.fromJson(json);

                        if (model.conversationId == duleModel.roomUid) {
                          model.updateOtherField(duleModel.msgTxt);
                          child = TextFormField(
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: model.otherTech,
                            onChanged: (value) {
                              model.updatTextFieldWidth();
                            },
                            readOnly: true,
                            cursorColor: AppColors.blue,
                            cursorHeight: 28,
                            cursorRadius: const Radius.circular(100),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 24),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                hintText: 'Message Received',
                                hintStyle: TextStyle(
                                    color: Colors.black38, fontSize: 24),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          );
                        } else {
                          child = const Center(
                            child: Text(
                              'User is offline.',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 24),
                            ),
                          );
                        }
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: child);
                      },
                    ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Type your message',
                          hintStyle: TextStyle(
                              color: Colors.white.withAlpha(200), fontSize: 24),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.5),
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
                      onPressed: () {
                        model.updateDuleFocus();
                      },
                      icon: const Icon((Icons.keyboard_alt_rounded)),
                      color: model.duleFocusNode.hasFocus
                          ? AppColors.blue
                          : AppColors.darkGrey,
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: () async {
                        final val = await model.getAnimationValue(
                            context: context,
                            confettiController: confettiController,
                            spotlightController: spotlightController);
                        log.wtf('Animation Value:$val');
                        if (val == AnimationType.confetti) {
                          await databaseService.updateUserDataWithKey(
                              DatabaseMessageField.aniType,
                              AnimationType.confetti);
                          // confettiController.play();
                          //  Future.delayed(const Duration(seconds: 3),()=> confettiController.stop());
                          await databaseService.updateUserDataWithKey(
                              DatabaseMessageField.aniType, null);
                        } else if (val == AnimationType.spotlight) {
                          spotlightController.forward();
                          await databaseService.updateUserDataWithKey(
                              DatabaseMessageField.aniType,
                              AnimationType.spotlight);
                        } else {
                          log.wtf('Animation is null');
                        }
                      },
                      icon: const Icon((Icons.emoji_emotions)),
                      color: AppColors.yellow,
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: () async {
                        await model.pickImage(context);
                      },
                      icon: const Icon((Icons.photo_camera)),
                      color: AppColors.darkGrey,
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: () {
                        model.pickFromGallery(context);
                      },
                      icon: const Icon((Icons.photo_library_rounded)),
                      color: AppColors.darkGrey,
                      iconSize: 32,
                    ),
                    const Spacer(),
                    Text(
                      model.wordLengthLeft,
                      style: const TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: () {
                        model.clearMessage();
                      },
                      icon: const Icon((Icons.delete)),
                      color: model.isDuleEmpty
                          ? AppColors.darkGrey
                          : AppColors.red,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
              bottomPadding(
                context,
              )
            ]),
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
                minimumSize: const Size(6, 6),
                maximumSize: const Size(12, 12),
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
