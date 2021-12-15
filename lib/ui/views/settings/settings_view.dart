import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/invites/invites_view.dart';
import 'package:hint/ui/views/settings/chats_customization/chat_customization_view.dart';
import 'package:hint/ui/views/settings/help/help_view.dart';
import 'package:hint/ui/views/settings/user_account/user_account_view.dart';
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
        backgroundColor: Colors.white,
        appBar: cwAuthAppBar(
          context,
          title: 'Settings',
          onPressed: () => Navigator.pop(context),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            //TODO: add what's new functionality here
            cwEADetailsTile(context, 'Whats\'s New 🎉🎉',
                titleColor: AppColors.blue),
            cwEADetailsTile(context, 'Account',
                subtitle: 'Personal Information,. Privacy', onTap: () {
              navService.cupertinoPageRoute(context, const UserAccountView());
            }),
            cwEADetailsTile(context, 'Chats', subtitle: 'Chats Customization',
                onTap: () {
              navService.cupertinoPageRoute(
                  context, const ChatsCustomizationView());
            }),
            cwEADetailsTile(context, 'Notifications',
                subtitle: 'Messages, Start Chat', onTap: () {
              // TODO: add notification page
              // navService.cupertinoPageRoute(context, const ());
            }),
            cwEADetailsTile(context, 'Help',
                subtitle: 'Help Center, Contact us, Privacy Policy', onTap: () {
              navService.cupertinoPageRoute(context, const HelpView());
            }),
            cwEADetailsTile(context, 'Invite', subtitle: 'Invites a Conatct',
                onTap: () {
              navService.cupertinoPageRoute(context, const InVitesView());
            }),
          ],
        ),
      ),
    );
  }
}
