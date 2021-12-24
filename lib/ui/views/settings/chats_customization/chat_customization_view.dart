import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/settings/chats_customization/widgets/change_bubble_color.dart';
import 'package:hint/ui/views/settings/chats_customization/widgets/change_keyword_dialog.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

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
                  const key = AppSettingKeys.darkTheme;
                  const boxName = HiveApi.appSettingsBoxName;
                  bool darkTheme =
                      Hive.box(boxName).get(key, defaultValue: false);
                  return Row(
                    children: [
                      Expanded(
                          child: cwEADetailsTile(context, 'Theme',
                              subtitle: darkTheme
                                  ? 'Tap to change to Light Mode'
                                  : 'Tap to change to Dark Mode',
                              showTrailingIcon: false)),
                      CupertinoSwitch(
                        value: darkTheme,
                        onChanged: (val) {
                          box.put(key, !darkTheme);
                        },
                      )
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
              ValueListenableBuilder<Box>(
                valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                builder: (context, box, child) {
                  const key = AppSettingKeys.confettiAnimation;
                  const boxName = HiveApi.appSettingsBoxName;
                  var value = Hive.box(boxName).get(key, defaultValue: 'Congo');
                  return cwEADetailsTile(context, 'Confetti', subtitle: value,
                      onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return const ChangeKeywordDialog(
                            animationType: AnimationType.confetti,
                          );
                        });
                  });
                },
              ),
              ValueListenableBuilder<Box>(
                valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                builder: (context, box, child) {
                  const key = AppSettingKeys.balloonsAnimation;
                  const boxName = HiveApi.appSettingsBoxName;
                  var value =
                      Hive.box(boxName).get(key, defaultValue: 'Balloons');
                  return cwEADetailsTile(context, 'Balloons', subtitle: value,
                      onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return const ChangeKeywordDialog(
                            animationType: AnimationType.balloons,
                          );
                        });
                  });
                },
              ),
              const Divider(),
              cwEADescriptionTitle(context,
                  'Magic words are those words which have a power to express your emotion on screen. When you type one of these words on your keyboard then a particular effects will display.'),
              verticalSpaceMedium,
              cwEADetailsTile(
                context,
                'Customization',
                subtitle: 'Set your settings for live chat',
                onTap: () {
                  bubbleColor(context, model);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
