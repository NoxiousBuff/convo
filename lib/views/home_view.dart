import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/views/social_view.dart';
import 'chat_list_view.dart';
import 'main_view.dart';

class HomeView extends StatefulWidget {
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
          items: [
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
              return MainView();
            case 1:
              return ChatListView();
            case 2:
              return SocialView();
            default:
              return ChatListView();
          }
        },
      ),
    );
  }
}
