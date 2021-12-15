import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:hint/ui/views/chat_list/widgets/light_clipper.dart';

import 'dule_viewmodel.dart';
import 'widget/video_display_widget.dart';

class DuleView extends StatefulWidget {
  const DuleView({Key? key, required this.fireUser}) : super(key: key);

  static const String id = '/DuleView';

  final FireUser fireUser;

  @override
  State<DuleView> createState() => _DuleViewState();
}

class _DuleViewState extends State<DuleView> with TickerProviderStateMixin {
  final radius = 0.0;
  bool lightOn = true;
  double x = 100, y = 100;
  bool incongonatedMode = false;
  final log = getLogger('DuleView');
  late ConfettiController confettiController;
  late AnimationController balloonsController;
  static const balloonsAnimationUrl =
      'https://assets3.lottiefiles.com/datafiles/6noNCcKTHSPTR58PUjeZyBEISORjlZceiZznmp02/balloons_animation.json';

  static const int blue300 = MaterialColorsCode.blue300;
  static const String hiveBox = HiveApi.appSettingsBoxName;
  static const String sKey = AppSettingKeys.senderBubbleColor;
  static const int lightBlue = MaterialColorsCode.lightBlue200;
  static const String rKey = AppSettingKeys.receiverBubbleColor;
  int rColorCode = Hive.box(hiveBox).get(rKey, defaultValue: blue300);
  int senderBubbleCode = Hive.box(hiveBox).get(sKey, defaultValue: lightBlue);

  @override
  void initState() {
    balloonsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    confettiController =
        ConfettiController(duration: const Duration(seconds: 4));

    confettiController.addListener(() => setState(() {}));
    balloonsController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    balloonsController.dispose();
    databaseService.updateUserDataWithKey(DatabaseMessageField.roomUid, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');

    chatService.addToRecentList(widget.fireUser.id);
    super.dispose();
  }

  StreamSubscription<DatabaseEvent> animationHandler() {
    final model = DuleViewModel(widget.fireUser);
    return model.stream.listen(
      (data) {
        final mapData = data.snapshot.value;
        final userDocMap = mapData;
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
          case AnimationType.balloons:
            {
              log.w('balloons controller :2');
              balloonsController.forward().whenComplete(() {
                return balloonsController.reset();
              });
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

  Widget receiverMediaWidget(DuleModel duleModel, DuleViewModel model) {
    switch (duleModel.urlType) {
      case MediaType.image:
        {
          const hash = 'L2I}t;RP00_N?vbHR5ni00xu^k8_';
          var width = (MediaQuery.of(context).size.width * 0.9).toInt();
          var height = (MediaQuery.of(context).size.height * 0.3).toInt();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Dismissible(
              onDismissed: (dissmissDirection) async {
                final fireUserId = widget.fireUser.id;
                const urlKey = DatabaseMessageField.url;
                const typeKey = DatabaseMessageField.urlType;
                await model.updateFireUserDataWithKey(fireUserId, urlKey, '');
                await model.updateFireUserDataWithKey(fireUserId, typeKey, '');
              },
              key: UniqueKey(),
              child: CachedNetworkImage(
                imageUrl: duleModel.url!,
                fit: BoxFit.cover,
                placeholder: (_, url) => ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image(
                    image: BlurHashImage(hash,
                        decodingHeight: height, decodingWidth: width),
                  ),
                ),
              ),
            ),
          );
        }
      case MediaType.video:
        {
          return Dismissible(
            onDismissed: (dissmissDirection) async {
              final fireUserId = widget.fireUser.id;
              const urlKey = DatabaseMessageField.url;
              const typeKey = DatabaseMessageField.urlType;
              await model.updateFireUserDataWithKey(fireUserId, urlKey, '');
              await model.updateFireUserDataWithKey(fireUserId, typeKey, '');
            },
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: VideoDisplayWidget(videoUrl: duleModel.url!),
            ),
          );
        }
      default:
        {
          return const Text('Deault Media Widget');
        }
    }
  }

  Widget receiverMessageBubble(BuildContext context, DatabaseEvent? data,
      DuleViewModel model, int receiverBubbleCode) {
    return StreamBuilder<DatabaseEvent>(
      stream: model.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log.wtf(snapshot.error);
          return const Text('There is an error');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          final data = snapshot.data;

          if (data != null) {
            final json = data.snapshot.value;
            final duleModel = DuleModel.fromJson(json);
            bool isInChatRoom = model.conversationId == duleModel.roomUid;
            var mediaUrl = duleModel.url;
            bool isMediaUrlNotNull = mediaUrl != null && mediaUrl.isNotEmpty;
            switch (isInChatRoom) {
              case true:
                {
                  model.updateOtherField(duleModel.msgTxt);

                  return Expanded(
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 200),
                      width: MediaQuery.of(context).size.width * 80,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                          color: incongonatedMode
                              ? Colors.transparent
                              : Color(receiverBubbleCode),
                          borderRadius: BorderRadius.circular(32)),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isMediaUrlNotNull
                            ? receiverMediaWidget(duleModel, model)
                            : TextFormField(
                                key: UniqueKey(),
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                readOnly: true,
                                maxLength: 160,
                                cursorHeight: 28,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                buildCounter: (_,
                                    {required currentLength,
                                    maxLength,
                                    required isFocused}) {
                                  return const SizedBox.shrink();
                                },
                                controller: model.otherTech,
                                cursorColor: AppColors.blue,
                                textAlign: TextAlign.center,
                                cursorRadius: const Radius.circular(100),
                                onChanged: (value) =>
                                    model.updatTextFieldWidth(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 24),
                                decoration: const InputDecoration(
                                  hintText: 'Message Received',
                                  hintStyle: TextStyle(
                                      color: Colors.black38, fontSize: 24),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                      ),
                    ),
                  );
                }

              case false:
                {
                  return const SizedBox.shrink();
                }

              default:
                {
                  return const SizedBox.shrink();
                }
            }
          } else {
            return const Text('Data is null now');
          }
        }
      },
    );
  }

  Widget senderMediaWidget(DuleViewModel model) {
    switch (model.sendingMediaType) {
      case MediaType.image:
        {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child:
                    Image.file(File(model.duleTech.text), fit: BoxFit.cover)),
          );
        }
      case MediaType.video:
        {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: VideoDisplayWidget(videoUrl: model.duleTech.text),
          );
        }
      default:
        {
          return const Center(child: Text('Media Widget'));
        }
    }
  }

  Widget senderMessageBubble(DuleViewModel model) {
    Widget switcherChild;
    if (!model.busy(model.controllerIsMedia)) {
      switcherChild = ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
          builder: (context, appSettingsbox, child) {
            const confettiKey = AppSettingKeys.confettiAnimation;
            const balloonsKey = AppSettingKeys.balloonsAnimation;
            String confettiVal =
                appSettingsbox.get(confettiKey, defaultValue: 'Congo');
            var balloonsVal =
                appSettingsbox.get(balloonsKey, defaultValue: 'Balloons');
            return TextFormField(
              focusNode: model.duleFocusNode,
              minLines: null,
              maxLines: null,
              expands: true,
              onChanged: (value) async {
                model.updateWordLengthLeft(value);
                model.updatTextFieldWidth();
                if (value.length <= 160) {
                  model.updateUserDataWithKey(
                      DatabaseMessageField.msgTxt, value);
                }
                if (value == confettiVal) {
                  var value = AnimationType.confetti;
                  await model.updateAnimation(value);
                  confettiController.play();
                  await model.updateAnimation(null);
                } else if (value == balloonsVal) {
                  var value = AnimationType.balloons;
                  await model.updateAnimation(value);
                  balloonsController
                      .forward()
                      .whenComplete(() => balloonsController.reset());
                  await model.updateAnimation(null);
                }
              },
              maxLength: 160,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) {
                return const SizedBox.shrink();
              },
              cursorHeight: 28,
              controller: model.duleTech,
              textAlign: TextAlign.center,
              cursorColor: AppColors.white,
              cursorRadius: const Radius.circular(100),
              style: const TextStyle(color: AppColors.white, fontSize: 24),
              decoration: InputDecoration(
                  hintText: 'Type your message',
                  hintStyle: TextStyle(
                      color: Colors.white.withAlpha(200), fontSize: 24),
                  border:
                      const OutlineInputBorder(borderSide: BorderSide.none)),
            );
          });
    } else {
      switcherChild = senderMediaWidget(model);
    }
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200), child: switcherChild);
  }

  @override
  Widget build(BuildContext context) {
    animationHandler();
    // setState(() {
    //   x = MediaQuery.of(context).size.width * 0.785;
    //   y = MediaQuery.of(context).size.height * 0.710;
    // });
    const dark = Brightness.dark;
    const systemUIOverlay = SystemUiOverlayStyle(statusBarIconBrightness: dark);
    return ViewModelBuilder<DuleViewModel>.reactive(
      onModelReady: (model) => model.createGetConversationId(),
      viewModelBuilder: () => DuleViewModel(widget.fireUser),
      builder: (BuildContext context, model, child) {
        final data = model.data;

        if (model.hasError) {
          return const Center(
            child: Text('Model has Error'),
          );
        }

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
                  color: incongonatedMode ? AppColors.white : Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
                horizontalDefaultMessageSpace,
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.fireUser.photoUrl,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.fireUser.displayName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18, color: Colors.black),
                ),
                data != null
                    ? DuleModel.fromJson(data.snapshot.value).online
                        ? const Text(
                            'Online',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 12),
                          )
                        : const SizedBox.shrink()
                    : const SizedBox.shrink(),
              ],
            ),
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
                balloonsAnimationUrl,
                width: screenWidth(context),
                controller: balloonsController,
                height: MediaQuery.of(context).size.height * 0.8,
              ),
              Column(
                children: [
                  topPadding(context),
                  const SizedBox(height: 56),
                  receiverMessageBubble(context, data, model, rColorCode),
                  verticalSpaceRegular,
                  Expanded(
                    flex: model.duleFlexFactor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        duration: const Duration(milliseconds: 200),
                        width: MediaQuery.of(context).size.width * 80,
                        decoration: BoxDecoration(
                            color: incongonatedMode
                                ? Colors.transparent
                                : Color(senderBubbleCode),
                            borderRadius: BorderRadius.circular(32)),
                        child: data != null
                            ? DuleModel.fromJson(data.snapshot.value).roomUid ==
                                    model.conversationId
                                ? senderMessageBubble(model)
                                : Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: cwAuthProceedButton(
                                      context,
                                      buttonTitle: 'Write a letter',
                                      onTap: () => navService.materialPageRoute(
                                        context,
                                        WriteLetterView(
                                          fireUser: widget.fireUser,
                                        ),
                                      ),
                                    ),
                                  )
                            : senderMessageBubble(model),
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
                          onPressed: () => showModalBottomSheet(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 100,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    InkWell(
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
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        var value = AnimationType.balloons;
                                        await model.updateAnimation(value);
                                        balloonsController
                                            .forward()
                                            .whenComplete(() =>
                                                balloonsController.reset());
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
                          ),
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
                        !model.isBusy
                            ? IconButton(
                                onPressed: () => model.pickGallery(context),
                                icon: const Icon(FeatherIcons.image),
                                color: AppColors.darkGrey,
                                iconSize: 32,
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.blue,
                                    ),
                                  ),
                                ),
                              ),
                        IconButton(
                          onPressed: () => navService.materialPageRoute(context,
                              WriteLetterView(fireUser: widget.fireUser)),
                          icon: const Icon(FeatherIcons.send),
                          color: AppColors.darkGrey,
                          iconSize: 32,
                        ),
                        const Spacer(),
                        Text(
                          model.wordLengthLeft,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
                  numberOfParticles: 400,
                  blastDirection: -pi / 4,
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
                  numberOfParticles: 400,
                  blastDirection: pi / 4,
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