import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/discover/discover_view.dart';
import 'package:hint/ui/views/explore/explore_view.dart';

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
          iconSize: 28.0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.messageCircle),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.search),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.compass),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.user),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return const  ChatListView();
            case 1:
              return const ExploreView();
            case 2:
              return const DiscoverView();
            default:
              return const ChatListView();
          }
        },
      ),
    );
  }
}
