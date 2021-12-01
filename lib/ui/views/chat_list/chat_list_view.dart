import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/recent_user.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/shared/empty_list_ui.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chat_list_viewmodel.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView>
    with AutomaticKeepAliveClientMixin<ChatListView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<ChatListViewModel>.reactive(
      disposeViewModel: true,
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                leading: const Material(
                  color: Colors.transparent,
                  child: Icon(FeatherIcons.linkedin),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.userPlus),
                        onPressed: () {},
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.send),
                        onPressed: () {
                          mainViewPageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        },
                      ),
                    ),
                  ],
                ),
                stretch: true,
                largeTitle: const Text('Friends'),
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: buildEmptyListUi(context),
                    ),
                    verticalSpaceRegular,
                    ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.recentChatsHiveBox),
                      builder: (context, box, child) {
                        final hive = box.values.toList();
                        final recentList = hive.map((value) {
                          var json = value.cast<String, dynamic>();
                          return RecentUser.fromJson(json);
                        }).toList();
                        recentList
                            .sort((a, b) => a.timestamp.compareTo(b.timestamp));
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: recentList.length,
                            itemBuilder: (context, i) {
                              final recentUser = recentList[i];
                              return UserListItem(userUid: recentUser.uid);
                            });
                      },
                    ),
                    verticalSpaceLarge,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
