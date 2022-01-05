import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/invites/invites_view.dart';
import 'package:hint/ui/views/settings/chats_customization/chat_customization_view.dart';
import 'package:hint/ui/views/settings/help/help_view.dart';
import 'package:hint/ui/views/settings/notification/notification_view.dart';
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
              navService.materialPageRoute(context, const InvitesView());
            }),
          ],
        ),
      ),
    );
  }
}
