import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/contacts/contacts.dart';

class DistantView extends StatelessWidget {
  const DistantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
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
                      navService.materialPageRoute(context, ChatListView());
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
                    onTap: () {},
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
                    onTap: () {
                      // navService.materialPageRoute(context, InterestsView());
                    },
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}