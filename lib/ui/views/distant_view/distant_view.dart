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
<<<<<<< HEAD
          ListTile(
            leading: ClipOval(
              child: ExtendedImage(
                image: NetworkImage(currentFireUser.photoUrl),
=======
          CustomScrollView(
            shrinkWrap: true,
            slivers: [
              CupertinoSliverNavigationBar(
                backgroundColor: CupertinoColors.extraLightBackgroundGray,
                largeTitle: const Text('Messages'),
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.black26, width: 0.5),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      navService.materialPageRoute(context, const ChatListView());
                    },
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    child: const ListTile(
                      title: Text('Messages'),
                      leading: Icon(CupertinoIcons.chat_bubble),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {
                      // navService.materialPageRoute(context, const UsernameAuthView());
                    },
                    child: const ListTile(
                      title: Text('Groups'),
                      leading: Icon(CupertinoIcons.person_2),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {
                      navService.materialPageRoute(
                          context, const ContactsView());
                    },
                    child: const ListTile(
                      title: Text('Contacts'),
                      leading: Icon(CupertinoIcons.doc),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      title: Text('Calls'),
                      leading: Icon(CupertinoIcons.doc),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      title: Text('Interest Based'),
                      leading: Icon(CupertinoIcons.doc),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {
                      // navService.materialPageRoute(
                      //     context, const AvatarRegisterView());
                    },
                    child: const ListTile(
                      title: Text('Avatar View'),
                      leading: Icon(CupertinoIcons.doc),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  const Divider(height: 0.0),
                  InkWell(
                    onTap: () {
                      AuthService().signOut(context);
                    },
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    child: const ListTile(
                      title: Text('LogOut'),
                      leading: Icon(CupertinoIcons.phone),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                ],
>>>>>>> c069fe14f9f4bcca90b9ed84715259209cd149ea
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
