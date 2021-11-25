import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';

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
        border: Border.all(color: transparent),
        backgroundColor: AppColors.blue,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: 25,
              ),
            ),
            Text(
              'Settings',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            leading: ClipOval(
              child: ExtendedImage(
                image: NetworkImage(currentFireUser.photoUrl),
              ),
            ),
            title: Text(currentFireUser.username),
            subtitle: Text(currentFireUser.bio),
          ),
          const Divider(height: 0),
          optionTile(
            context,
            icon: CupertinoIcons.person,
            title: 'Account',
            subtitle: 'Privacy, Security, Change Number',
          ),
          optionTile(context,
              icon: CupertinoIcons.chat_bubble,
              title: 'Chats',
              subtitle: 'Chats Customization'),
          optionTile(context,
              icon: CupertinoIcons.bell,
              title: 'Notifications',
              subtitle: 'Messages, Start Chat'),
          optionTile(context,
              icon: CupertinoIcons.question_circle,
              title: 'Help',
              subtitle: 'Help Center, Contact us, Privacy Policy'),
          optionTile(context,
              icon: CupertinoIcons.person_2, title: 'Invites a Conatct')
        ],
      ),
    );
  }
}
