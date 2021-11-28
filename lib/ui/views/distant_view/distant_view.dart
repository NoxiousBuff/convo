import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/settings/help_view.dart';
import 'package:hint/ui/views/settings/chats_customization/chat_customization.dart';
import 'package:hint/ui/views/user_account/account_view.dart';

class DistantView extends StatelessWidget {
  final FireUser currentFireUser;
  const DistantView({Key? key, required this.currentFireUser})
      : super(key: key);

  Widget optionTile(
    BuildContext context, {
    String? subtitle,
    required String title,
    required IconData icon,
    void Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black26,
        size: 14.0,
      ),
      subtitle: Text(subtitle ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyMiddle: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Divider(height: 0),
          optionTile(context,
              icon: CupertinoIcons.person,
              title: 'Account',
              subtitle: 'Privacy, Security, Change Number',
              onTap: () => navService.cupertinoPageRoute(
                  context, Account(fireUser: currentFireUser))),
          optionTile(context,
              icon: CupertinoIcons.chat_bubble,
              title: 'Chats',
              subtitle: 'Chats Customization',
              onTap: () =>
                  navService.cupertinoPageRoute(context, const Chats())),
          optionTile(context,
              icon: CupertinoIcons.bell,
              title: 'Notifications',
              subtitle: 'Messages, Start Chat'),
          optionTile(context,
              icon: CupertinoIcons.question_circle,
              title: 'Help',
              subtitle: 'Help Center, Contact us, Privacy Policy',
              onTap: () =>
                  navService.cupertinoPageRoute(context, const HelpView())),
          optionTile(context,
              icon: CupertinoIcons.person_2, title: 'Invites a Conatct')
        ],
      ),
    );
  }
}