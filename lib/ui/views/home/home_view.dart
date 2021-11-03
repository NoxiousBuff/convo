import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/explore/explore_view.dart';
import 'package:hint/ui/views/interest/interest_view.dart';

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
          backgroundColor: LightAppColors.surface,
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
              return const InterestView();
            case 1:
              return ChatListView();
            case 2:
              return const ExploreView();
            default:
              return ChatListView();
          }
        },
      ),
    );
  }
}
