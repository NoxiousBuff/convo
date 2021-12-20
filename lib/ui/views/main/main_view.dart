import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/pods/page_controller_pod.dart';
import 'package:hint/ui/views/account/account_view/account_view.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/discover/discover_view.dart';
import 'package:hint/ui/views/explor/explor_view.dart';
import 'package:hint/ui/views/explore/explore_view.dart';

final PageController mainViewPageController =
    PageController(keepPage: true, initialPage: 0);

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  static const String id = '/MainView';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          ref, Widget? child) {
        final pageControllerProvider = ref.watch(pageControllerPod);
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor:AppColors.black,
            iconSize: 28.0,
            backgroundColor: AppColors.scaffoldColor,
            onTap: (currentIndex) {
              pageControllerProvider.currentIndexChanger(currentIndex);
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
                return const ExplorView();
              case 2:
                return const DiscoverView();
              case 3:
                return const AccountView();
              default:
                return const ChatListView();
            }
          },
        );
      },
    );
  }
}
