import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hint/ui/views/social/social_view.dart';
import 'package:hint/ui/views/recent_chats/recent_chats.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoTabScaffold(
        backgroundColor: Colors.white,
        tabBar: CupertinoTabBar(
          activeColor: CupertinoColors.black,
          iconSize: 25.0,
          backgroundColor: Colors.white,
          items: const  [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.scribble),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.memories),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return const MainView();
            case 1:
              return const RecentChats();
            case 2:
              return const SocialView();
            default:
              return const RecentChats();
          }
        },
      ),
    );
  }
}
