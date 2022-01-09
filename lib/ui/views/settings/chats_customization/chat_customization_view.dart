import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
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
                'Message Bubble Color',
                subtitle: 'Tap to change message bubble color',
                onTap: () => bubbleColor(context, model),
              ),
            ],
          ),
        );
      },
    );
  }
}
