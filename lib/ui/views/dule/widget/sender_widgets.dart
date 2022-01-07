import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/dule/dule_viewmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'sender_video_diaplay_widget.dart';

Widget senderMediaWidget(
    BuildContext context, DuleViewModel model, double uploadingProgress) {
  String progress = (uploadingProgress * 100).toInt().toString();
  switch (model.sendingMediaType) {
    case MediaType.image:
      {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          constraints: const BoxConstraints(maxHeight: 35, maxWidth: 35),
          child: ExtendedImage.file(
            File(model.sendingMediaPath!),
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  {
                    return const CircularProgress(height: 30, width: 30);
                  }
                case LoadState.completed:
                  {
                    return Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ExtendedRawImage(
                            width: 35,
                            height: 35,
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                            image: state.extendedImageInfo?.image,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 35,
                          color: Colors.black26,
                        ),
                        Center(
                          child: Text(
                            progress,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.white),
                          ),
                        ),
                      ],
                    );
                  }
                case LoadState.failed:
                  {
                    return Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                      ),
                      child: const Icon(FeatherIcons.info),
                    );
                  }
                default:
                  {
                    return shrinkBox;
                  }
              }
            },
          ),
        );
      }
    case MediaType.video:
      {
        return SenderVideoDisplayWidget(
          videoPath: model.sendingMediaPath!,
          uploadingProgress: uploadingProgress,
        );
      }
    default:
      {
        return const Center(child: Text('Media Widget'));
      }
  }
}

/// current user message bubble textfield
Widget senderMessageContent(
  BuildContext context, {
  required DuleViewModel model,
  required AnimationController heartsController,
  required ConfettiController confettiController,
  required AnimationController balloonsController,
}) {
  Widget switcherChild;
  switcherChild = ValueListenableBuilder<Box>(
      valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
      builder: (context, box, child) {
        const hKey = AppSettingKeys.heartsAnimation; // hearts key
        const cKey = AppSettingKeys.confettiAnimation; // confetti key
        const bKey = AppSettingKeys.balloonsAnimation; // balloons key
        final String heartsVal = box.get(hKey, defaultValue: 'Hearts');
        final String confettiVal = box.get(cKey, defaultValue: 'Congo');
        final String balloonsVal = box.get(bKey, defaultValue: 'Balloons');
        return TextFormField(
          focusNode: model.duleFocusNode,
          minLines: null,
          maxLines: null,
          expands: true,
          onChanged: (value) {
            model.updateWordLengthLeft(value);
            model.updatTextFieldWidth();
            if (value.length <= 160) {
              model.updateUserDataWithKey(DatabaseMessageField.msgTxt, value);
            }

            if (value == confettiVal) {
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 300),
                  () => confettiController.play());
              model
                  .updateAnimation(AnimationType.confetti)
                  .whenComplete(() => model.updateAnimation(null));
            } else if (value == balloonsVal) {
              FocusScope.of(context).unfocus();
              balloonsController
                  .forward()
                  .whenComplete(() => balloonsController.reset());
              model
                  .updateAnimation(AnimationType.balloons)
                  .whenComplete(() => model.updateAnimation(null));
            } else if (value == heartsVal) {
              FocusScope.of(context).unfocus();
              heartsController
                  .forward()
                  .whenComplete(() => heartsController.reset());
              model
                  .updateAnimation(AnimationType.hearts)
                  .whenComplete(() => model.updateAnimation(null));
            } else {}
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
          cursorColor: Theme.of(context).colorScheme.white,
          cursorRadius: const Radius.circular(100),
          style: TextStyle(
              color: Theme.of(context).colorScheme.white, fontSize: 24),
          decoration: InputDecoration(
              hintText: 'Type your message',
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.white.withAlpha(200),
                  fontSize: 24),
              border: const OutlineInputBorder(borderSide: BorderSide.none)),
        );
      });
  return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200), child: switcherChild);
}

/// Message bubble of current user
Widget senderMessageBubble(
  BuildContext context, {
  required FireUser fireUser,
  required DuleViewModel model,
  required DatabaseEvent? data,
  required AnimationController heartsController,
  required ConfettiController confettiController,
  required AnimationController balloonsController,
}) {
  const String hiveBox = HiveApi.appSettingsBoxName;
  const String sKey = AppSettingKeys.senderBubbleColor;
  const int deepPurple = MaterialColorsCode.deepPurple500;
  int senderBubbleCode = Hive.box(hiveBox).get(sKey, defaultValue: deepPurple);
  return Expanded(
    flex: model.duleFlexFactor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        duration: const Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width * 80,
        decoration: BoxDecoration(
            color: Color(senderBubbleCode),
            borderRadius: BorderRadius.circular(32)),
        // child: data != null
        //     ? DuleModel.fromJson(data.snapshot.value).roomUid ==
        //             model.conversationId
        //         ? senderMessageContent(
        //             context,
        //             model: model,
        //             heartsController: heartsController,
        //             confettiController: confettiController,
        //             balloonsController: balloonsController,
        //           )
        //         : TextButton.icon(
        //             style: TextButton.styleFrom(
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(12)),
        //             ),
        //             onPressed: () => navService.materialPageRoute(
        //               context,
        //               WriteLetterView(fireUser: fireUser),
        //             ),
        //             icon: Icon(FeatherIcons.send,
        //                 color: Theme.of(context).colorScheme.mediumBlack),
        //             label: Text(
        //               'Send a letter',
        //               style: TextStyle(
        //                   color: Theme.of(context).colorScheme.mediumBlack,
        //                   fontSize: 24,
        //                   decoration: TextDecoration.underline),
        //             ),
        //           )
        //     : TextButton.icon(
        //         style: TextButton.styleFrom(
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12)),
        //         ),
        //         onPressed: () => navService.materialPageRoute(
        //           context,
        //           WriteLetterView(fireUser: fireUser),
        //         ),
        //         icon: Icon(FeatherIcons.send,
        //             color: Theme.of(context).colorScheme.mediumBlack),
        //         label: Text(
        //           'Send a letter',
        //           style: TextStyle(
        //               fontSize: 24,
        //               decoration: TextDecoration.underline,
        //               color: Theme.of(context).colorScheme.mediumBlack),
        //         ),
        //       ),
        child: senderMessageContent(
          context,
          model: model,
          heartsController: heartsController,
          confettiController: confettiController,
          balloonsController: balloonsController,
        ),
      ),
    ),
  );
}
