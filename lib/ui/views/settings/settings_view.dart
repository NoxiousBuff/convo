import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/pods/settings_pod.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/settings/chats_customization/chat_customization_view.dart';
import 'package:hint/ui/views/settings/help/help_view.dart';
import 'package:hint/ui/views/settings/notification/notification_view.dart';
import 'package:hint/ui/views/settings/user_account/user_account_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const String id = '/SettingsView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(
          context,
          title: 'Settings',
          onPressed: () => Navigator.pop(context),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          children: [
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
                        dropdownColor: Theme.of(context).colorScheme.lightGrey,
                        underline: shrinkBox,
                        value: settingsPod.appThemeInString,
                        elevation: 0,
                        onChanged: (chosenThemeMode) {
                          if (chosenThemeMode != null) {
                            settingsPod.updateTheme(chosenThemeMode);
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
            const Divider(),
            cwEADetailsTile(context, 'Account',
                subtitle: 'Personal Information,. Privacy', onTap: () {
              navService.materialPageRoute(context, const UserAccountView());
            }),
            cwEADetailsTile(context, 'Chats', subtitle: 'Chats Customization',
                onTap: () {
              navService.materialPageRoute(
                  context, const ChatsCustomizationView());
            }),
            cwEADetailsTile(context, 'Notifications',
                subtitle: 'Zap, Letter, Discover, Security', onTap: () {
              navService.materialPageRoute(context, const NotificationView());
            }),
            cwEADetailsTile(context, 'Help',
                subtitle: 'Help Center, Contact us, Privacy Policy', onTap: () {
              navService.materialPageRoute(context, const HelpView());
            }),
            cwEADetailsTile(context, 'Get Your Friends',
                subtitle: 'More the merrier , you know.', onTap: () {
              model.invitePeople();
            },  icon: FeatherIcons.externalLink ),
            cwEADetailsTile(context, 'Send Suggestions',
                subtitle: 'Report any bug and feature you would want to see.', onTap: () {
              model.openEmailClient();
            }, icon: FeatherIcons.externalLink ),
          ],
        ),
      ),
    );
  }
}
