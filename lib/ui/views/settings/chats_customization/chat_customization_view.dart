import 'dart:developer';
import 'package:hint/ui/views/onboarding/onboarding_view.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/pods/settings_pod.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/settings/chats_customization/widgets/change_bubble_color.dart';
import 'package:hint/ui/views/settings/chats_customization/widgets/change_keyword_dialog.dart';

import 'chat_customization_viewmodel.dart';

class ChatsCustomizationView extends StatelessWidget {
  const ChatsCustomizationView({Key? key}) : super(key: key);

  Future<void> bubbleColor(
      BuildContext context, ChatsCustomizationViewModel model) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      context: context,
      builder: (context) {
        return ChangebubbleColor(model: model);
      },
    );
  }

  Widget magicWordsTile(
      {required String title,
      required String hiveBox,
      required String defaultValue,
      required String animationType}) {
    return ValueListenableBuilder<Box>(
      valueListenable: hiveApi.hiveStream(hiveBox),
      builder: (context, box, child) {
        const key = AppSettingKeys.heartsAnimation;
        var value = box.get(key, defaultValue: defaultValue);
        return cwEADetailsTile(
          context,
          title,
          subtitle: value,
          onTap: () => navService.materialPageRoute(
            context,
            ChangeKeywordDialog(animationType: animationType),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsCustomizationViewModel>.reactive(
      viewModelBuilder: () => ChatsCustomizationViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context, title: 'Chats', onPressed: () {
            Navigator.pop(context);
          }),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  cwEADescriptionTitle(context, 'Display'),
                ],
              ),
              verticalSpaceRegular,
              ValueListenableBuilder<Box>(
                valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                builder: (context, box, child) {
                  return Row(
                    children: [
                      Expanded(
                          child: cwEADetailsTile(context, 'Theme',
                              subtitle: 'Tap to change to app theme',
                              showTrailingIcon: false)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.lightGrey,
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 2),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(14.2),
                          dropdownColor:
                              Theme.of(context).colorScheme.lightGrey,
                          underline: shrinkBox,
                          value: settingsPod.appThemeInString,
                          elevation: 0,
                          onChanged: (chosenThemeMode) {
                            if (chosenThemeMode != null) {
                              settingsPod.updateTheme(chosenThemeMode);
                              log(chosenThemeMode);
                              log(settingsPod.appThemeInString);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: AppThemes.system,
                              child: Text('System'),
                            ),
                            DropdownMenuItem(
                              value: AppThemes.light,
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(
                              value: AppThemes.dark,
                              child: Text('Dark'),
                            )
                          ],
                        ),
                      ),
                      horizontalSpaceRegular,
                    ],
                  );
                },
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  cwEADescriptionTitle(context, 'Magic Words'),
                ],
              ),
              verticalSpaceRegular,
              magicWordsTile(
                title: 'Confetti',
                defaultValue: 'Congo',
                hiveBox: HiveApi.appSettingsBoxName,
                animationType: AnimationType.confetti,
              ),
              magicWordsTile(
                  title: 'Balloons',
                  defaultValue: 'Balloons',
                  hiveBox: HiveApi.appSettingsBoxName,
                  animationType: AnimationType.balloons),
              magicWordsTile(
                  title: 'Hearts',
                  defaultValue: 'Hearts',
                  hiveBox: HiveApi.appSettingsBoxName,
                  animationType: AnimationType.hearts),
              const Divider(),
              cwEADescriptionTitle(context,
                  'Magic words are those words which have a power to express your emotion on screen. When you type one of these words on your keyboard then a particular effects will display.'),
              verticalSpaceMedium,
              cwEADetailsTile(
                context,
                'Customization',
                subtitle: 'Set your settings for live chat',
                onTap: () => bubbleColor(context, model),
              ),
              cwEADetailsTile(context, 'On Boarding', subtitle: 'On Boarding View', onTap: () {
                navService.cupertinoPageRoute(context,  OnBoardingView());
              }),
            ],
          ),
        );
      },
    );
  }
}