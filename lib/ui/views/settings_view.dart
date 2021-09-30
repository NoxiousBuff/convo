import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final key = GlobalKey<FormState>();

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  bool personalChat = false;

  bool groupChat = false;

  title({required String title, required IconData icon}) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: Icon(
              icon,
              color: CupertinoColors.inactiveGray,
            ),
            onPressed: () {},
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const Divider(height: 0.0),
      ],
    );
  }

  subtitle({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: IconButton(
            icon: Icon(icon, color: CupertinoColors.lightBackgroundGray),
            onPressed: () {},
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.button,
          ),
        ),
        const Divider(height: 0.0),
      ],
    );
  }

  switchWidget(
      {required Widget trailing,
      required Function() onTap,
      required IconData icon,
      required String title}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: IconButton(
            icon: Icon(
              icon,
              color: CupertinoColors.lightBackgroundGray,
            ),
            onPressed: () {},
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: trailing,
        ),
        const Divider(height: 0.0),
      ],
    );
  }

  container({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: CupertinoColors.white,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: ListView(
        children: [
          container(
            child: Column(
              children: [
                title(title: 'USER SETTINGS', icon: CupertinoIcons.person),
                subtitle(
                  title: 'Email',
                  icon: CupertinoIcons.mail,
                  onTap: () {},
                ),
                subtitle(
                  title: 'Username',
                  icon: CupertinoIcons.person_alt,
                  onTap: () {},
                ),
                subtitle(
                  title: 'Password',
                  icon: CupertinoIcons.eye_fill,
                  onTap: () {},
                ),
                subtitle(
                    title: 'Blocked users', icon: Icons.block, onTap: () {}),
                subtitle(
                  title: 'Delete account',
                  icon: CupertinoIcons.delete,
                  onTap: () {},
                ),
              ],
            ),
          ),
          container(
            child: Column(
              children: [
                title(title: 'NOTIFICATION', icon: CupertinoIcons.bell),
                switchWidget(
                  onTap: () {},
                  icon: CupertinoIcons.chat_bubble_2,
                  title: 'Group Chat',
                  trailing: CupertinoSwitch(
                    value: groupChat,
                    onChanged: (bool value) {
                      setState(() {
                        groupChat = value;
                      });
                    },
                  ),
                ),
                switchWidget(
                  onTap: () {},
                  icon: CupertinoIcons.chat_bubble,
                  title: 'Personal Chat',
                  trailing: CupertinoSwitch(
                    value: personalChat,
                    onChanged: (bool value) {
                      setState(() {
                        personalChat = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          container(
            child: Column(
              children: [
                title(title: 'APP INFORMATION', icon: CupertinoIcons.info),
                subtitle(
                    title: 'Updated',
                    icon: CupertinoIcons.news_solid,
                    onTap: () {}),
                subtitle(
                    title: 'Privacy & Policy',
                    icon: CupertinoIcons.doc_fill,
                    onTap: () {}),
                subtitle(
                    title: 'Terms & Conditions',
                    icon: CupertinoIcons.doc,
                    onTap: () {}),
                subtitle(
                    title: 'Upcoming features',
                    icon: CupertinoIcons.hand_point_right,
                    onTap: () {}),
              ],
            ),
          ),
          container(
            child: Column(
              children: [
                title(title: 'HELP', icon: CupertinoIcons.question_circle),
                subtitle(
                    title: 'Feedback',
                    icon: CupertinoIcons.arrow_right,
                    onTap: () {}),
                subtitle(
                    title: 'Hint FAQ',
                    icon: CupertinoIcons.question_square,
                    onTap: () {}),
                subtitle(
                    title: 'Ask a question',
                    icon: CupertinoIcons.question,
                    onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
