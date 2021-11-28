import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/pods/page_controller_pod.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/discover/discover_view.dart';
import 'package:hint/ui/views/explore/explore_view.dart';
import 'package:hint/ui/views/profile/profile_view.dart';

final PageController mainViewPageController =
    PageController(keepPage: true, initialPage: 0);

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  static const String id = '/MainView';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
        final pageControllerProvider = watch(pageControllerPod);
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: Colors.black,
            iconSize: 28.0,
            backgroundColor: Colors.white,
            onTap: (currentIndex) {
              pageControllerProvider.currentIndexChanger(currentIndex);
              log(currentIndex.toString());
            },
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
                return const ChatListView();
              case 1:
                return const ExploreView();
              case 2:
                return const DiscoverView();
              case 3:
                return const ProfileView();
              default:
                return const ChatListView();
            }
          },
        );
      },
    );
  }
}
