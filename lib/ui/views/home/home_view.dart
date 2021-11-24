import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        tabBar: CupertinoTabBar(
          activeColor: Colors.black,
          iconSize: 25.0,
          // backgroundColor: AppColors.blue.withAlpha(20),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
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
