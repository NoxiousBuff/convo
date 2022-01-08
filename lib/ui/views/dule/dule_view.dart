import 'dart:math';
import 'dart:async';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/profile/profile_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/dule/widget/sender_widgets.dart';
import 'package:hint/ui/views/dule/widget/receiver_widgets.dart';
import 'package:hint/ui/views/dule/widget/animation_widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';

import 'dule_viewmodel.dart';

class DuleView extends StatefulWidget {
  const DuleView({Key? key, required this.fireUser}) : super(key: key);

  static const String id = '/DuleView';

  final FireUser fireUser;

  @override
  State<DuleView> createState() => _DuleViewState();
}

class _DuleViewState extends State<DuleView> with TickerProviderStateMixin {
  late AnimationController heartsController;
  late ConfettiController confettiController;
  late AnimationController balloonsController;
  static const duration = Duration(seconds: 4);
  static const String hiveBox = HiveApi.appSettingsBoxName;
  static const String sKey = AppSettingKeys.senderBubbleColor;
  static const int lightBlue = MaterialColorsCode.lightBlue200;
  int senderBubbleCode = Hive.box(hiveBox).get(sKey, defaultValue: lightBlue);

  @override
  void initState() {
    databaseService.updateUserDataWithKey(DatabaseMessageField.url, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.urlType, '');

    confettiController = ConfettiController(duration: duration);
    heartsController = AnimationController(vsync: this, duration: duration);
    balloonsController = AnimationController(vsync: this, duration: duration);

    heartsController.addListener(() => setState(() {}));
    confettiController.addListener(() => setState(() {}));
    balloonsController.addListener(() => setState(() {}));


    super.initState();
  }

  @override
  void dispose() {
    heartsController.dispose();
    confettiController.dispose();
    balloonsController.dispose();

    databaseService.updateUserDataWithKey(DatabaseMessageField.roomUid, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    databaseService.updateUserDataWithKey(DatabaseMessageField.url, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.urlType, '');

    chatService.addToRecentList(widget.fireUser.id);
    super.dispose();
  }

  /// handle animations controller for playing them
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
              confettiController.play();
            }
            break;
          case AnimationType.balloons:
            {
              balloonsController.forward();
            }
            break;
          case AnimationType.hearts:
            {
              heartsController.forward();
            }
            break;
          default:
            {}
        }
      },
      onError: (e) {
        model.log.e('StreamSubscription For Animation Error:$e');
      },
    );
  }

  AppBar _buildAppBar(BuildContext context,
      {required DatabaseEvent? data, required Stream<DatabaseEvent> stream}) {
    final appBarBrightness =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;
    final systemUIOverlay =
        SystemUiOverlayStyle(statusBarIconBrightness: appBarBrightness);
    return AppBar(
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
            color: Theme.of(context).colorScheme.black,
            onPressed: () => Navigator.pop(context),
          ),
          horizontalDefaultMessageSpace,
          InkWell(
            onTap: () => navService.materialPageRoute(
                context, ProfileView(fireUser: widget.fireUser)),
            child: userProfilePhoto(context, widget.fireUser.photoUrl,
                height: 50, width: 50),
          ),
        ],
      ),
      title: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.fireUser.displayName,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 18, color: Theme.of(context).colorScheme.black),
            overflow: TextOverflow.ellipsis,
          ),
          data != null
              ? DuleModel.fromJson(data.snapshot.value).online
                  ? Text(
                      'Online',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.mediumBlack,
                          fontSize: 12),
                    )
                  : shrinkBox
              : shrinkBox,
        ],
      ),
      actions: [
        data != null
            ? AppBarMediaVisibility(
                widget.fireUser, stream)
            : shrinkBox,
        IconButton(
          onPressed: () {
            pushNotificationService.sendZap(
                  widget.fireUser.id,
                  whenComplete: () => customSnackbars.successSnackbar(context,
                      title: 'He has been notified.'),
                  onError: () => customSnackbars.errorSnackbar(context,
                      title: 'There was some error in notifying. Please check your internet connection.'),
                );
          },
          icon: const Icon(FeatherIcons.zap),
          color: Theme.of(context).colorScheme.black,
        ),
      ],
    );
  }

  Widget _buildBottomOptions(BuildContext context, DuleViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        horizontalSpaceRegular,
        IconButton(
          onPressed: () => model.updateDuleFocus(),
          icon: const Icon(FeatherIcons.edit3),
          color: model.duleFocusNode.hasFocus
              ? Color(senderBubbleCode)
              : Theme.of(context).colorScheme.darkGrey,
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    horizontalSpaceRegular,
                    InkWell(
                        onTap: () {
                          Navigator.pop(context, true);
                          var value = AnimationType.confetti;
                          Future.delayed(const Duration(milliseconds: 150),
                              () => confettiController.play());
                          model
                              .updateAnimation(value)
                              .whenComplete(() => model.updateAnimation(null));
                        },
                        child: const Chip(label: Text('Confetti'))),
                    horizontalSpaceRegular,
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          var value = AnimationType.hearts;
                          heartsController
                              .forward()
                              .whenComplete(() => heartsController.reset());
                          model
                              .updateAnimation(value)
                              .whenComplete(() => model.updateAnimation(null));
                        },
                        child: const Chip(label: Text('Hearts'))),
                    horizontalSpaceRegular,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        var value = AnimationType.balloons;
                        balloonsController
                            .forward()
                            .whenComplete(() => balloonsController.reset());
                        model
                            .updateAnimation(value)
                            .whenComplete(() => model.updateAnimation(null));
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
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        model.isBusy
            ? senderMediaWidget(context, model, model.uploadingProgress)
            : IconButton(
                onPressed: () => model.pickImage(context),
                icon: const Icon(FeatherIcons.camera),
                color: Theme.of(context).colorScheme.darkGrey,
                iconSize: 32,
              ),
        model.busy(model.isGalleryUploading) && model.sendingMediaPath != null
            ? senderMediaWidget(context, model, model.uploadingProgress)
            : IconButton(
                onPressed: () => model.pickGallery(context),
                icon: const Icon(FeatherIcons.image),
                color: Theme.of(context).colorScheme.darkGrey,
                iconSize: 32,
              ),
        IconButton(
          onPressed: () => navService.materialPageRoute(
              context, WriteLetterView(fireUser: widget.fireUser)),
          icon: const Icon(FeatherIcons.send),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        const Spacer(),
        Text(
          model.wordLengthLeft,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Theme.of(context).colorScheme.darkGrey),
        ),
        IconButton(
          onPressed: () => model.clearMessage(),
          icon: const Icon((FeatherIcons.refreshCcw)),
          color: model.isDuleEmpty
              ? Theme.of(context).colorScheme.darkGrey
              : Theme.of(context).colorScheme.red,
          iconSize: 32,
        ),
        horizontalSpaceTiny,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    animationHandler();

    return ViewModelBuilder<DuleViewModel>.reactive(
      onModelReady: (model) => model.createGetConversationId(),
      viewModelBuilder: () => DuleViewModel(widget.fireUser),
      builder: (BuildContext context, model, child) {
        final data = model.data;

        if (model.hasError) const Center(child: Text('Model has Error'));

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context, data: data, stream: model.stream),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  topPadding(context),
                  const SizedBox(height: 56),
                  verticalSpaceSmall,
                  receiverMessageBubble(
                    context,
                    data: data,
                    model: model,
                    fireUser: widget.fireUser,
                  ),
                  verticalSpaceRegular,
                  senderMessageBubble(context,
                      data: data,
                      model: model,
                      fireUser: widget.fireUser,
                      heartsController: heartsController,
                      confettiController: confettiController,
                      balloonsController: balloonsController),
                  _buildBottomOptions(context, model),
                  bottomPadding(context),
                ],
              ),
              confettiAnimation(context, confettiController, pi / 4),
              confettiAnimation(context, confettiController, -pi / 4,
                  isLeft: true),
              balloonsController.isAnimating
                  ? balloonsLottieAnimation(context, balloonsController)
                  : shrinkBox,
              heartsController.isAnimating
                  ? heartsLottieAnimation(context, heartsController)
                  : shrinkBox,
            ],
          ),
        );
      },
    );
  }
}