import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/dule/dule_viewmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';

import 'sender_video_diaplay_widget.dart';

Widget senderMediaWidget(
    BuildContext context, DuleViewModel model, double uploadingProgress) {
  String progress = (uploadingProgress * 100).toInt().toString();
  switch (model.sendingMediaType) {
    case MediaType.image:
      {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          constraints: const BoxConstraints(maxHeight: 35, maxWidth: 60),
          child: ExtendedImage.file(
            File(model.sendingMediaPath!),
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  {
                    return const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 2.0));
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
                            width: 60,
                            height: 35,
                            isAntiAlias: true,
                            fit: BoxFit.fitWidth,
                            image: state.extendedImageInfo?.image,
                          ),
                        ),
                        Center(
                          child: Text(
                            progress,
                            style:  TextStyle(color: Theme.of(context).colorScheme.white),
                          ),
                        ),
                      ],
                    );
                  }
                case LoadState.failed:
                  {
                    return const Text('Failed To Load Image');
                  }
                default:
                  {
                    return const SizedBox.shrink();
                  }
              }
            },
          ),
        );
      }
    case MediaType.video:
      {
        return Container(
          constraints: const BoxConstraints(maxHeight: 35, maxWidth: 60),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SenderVideoDisplayWidget(
            videoPath: model.sendingMediaPath!,
            uploadingProgress: uploadingProgress,
          ),
        );
      }
    default:
      {
        return const Center(child: Text('Media Widget'));
      }
  }
}

Widget senderMessageContent(
  BuildContext context, {
  required DuleViewModel model,
  required ConfettiController confettiController,
  required AnimationController balloonsController,
}) {
  Widget switcherChild;
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
              model.updateUserDataWithKey(DatabaseMessageField.msgTxt, value);
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
          cursorColor: Theme.of(context).colorScheme.white,
          cursorRadius: const Radius.circular(100),
          style:  TextStyle(color: Theme.of(context).colorScheme.white, fontSize: 24),
          decoration: InputDecoration(
              hintText: 'Type your message',
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.white.withAlpha(200), fontSize: 24),
              border: const OutlineInputBorder(borderSide: BorderSide.none)),
        );
      });
  return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200), child: switcherChild);
}

Widget senderMessageBubble(
  BuildContext context, {
  required DuleViewModel model,
  required ConfettiController confettiController,
  required AnimationController balloonsController,
  required DatabaseEvent? data,
  required FireUser fireUser,
}) {
  const String hiveBox = HiveApi.appSettingsBoxName;
  const String sKey = AppSettingKeys.senderBubbleColor;
  const int lightBlue = MaterialColorsCode.lightBlue200;
  int senderBubbleCode = Hive.box(hiveBox).get(sKey, defaultValue: lightBlue);
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
        child: data != null
            ? DuleModel.fromJson(data.snapshot.value).roomUid ==
                    model.conversationId
                ? senderMessageContent(
                    context,
                    model: model,
                    confettiController: confettiController,
                    balloonsController: balloonsController,
                  )
                : TextButton.icon(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => navService.materialPageRoute(
                      context,
                      WriteLetterView(
                        fireUser: fireUser,
                      ),
                    ),
                    icon: Icon(FeatherIcons.send,
                        color: Theme.of(context).colorScheme.mediumBlack),
                    label: Text(
                      'Send a letter',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.mediumBlack,
                          fontSize: 24,
                          decoration: TextDecoration.underline),
                    ),
                  )
            : TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => navService.materialPageRoute(
                  context,
                  WriteLetterView(
                    fireUser: fireUser,
                  ),
                ),
                icon: Icon(FeatherIcons.send,
                    color: Theme.of(context).colorScheme.mediumBlack),
                label: Text(
                  'Send a letter',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.mediumBlack,
                      fontSize: 24,
                      decoration: TextDecoration.underline),
                ),
              ),
      ),
    ),
  );
}
