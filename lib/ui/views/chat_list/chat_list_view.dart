import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/recent_user.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';

import 'chat_list_viewmodel.dart';

class ChatListView extends StatefulWidget  {
  const ChatListView({Key? key}) : super(key: key);


  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> with AutomaticKeepAliveClientMixin<ChatListView> {
  final log = getLogger('ChatListView');

  final ChatListViewModel model = ChatListViewModel();

  Widget shimmerListTile(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: ClipOval(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade300.withAlpha(30),
                Colors.indigo.shade400.withAlpha(50),
              ],
              focal: Alignment.topLeft,
              radius: 0.8,
            ),
          ),
          height: 56.0,
          width: 56.0,
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.1)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: screenWidthPercentage(context, percentage: 0.4)),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
    );
  }

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
                        onPressed: () {
                          
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.send),
                        onPressed: () {
                          mainViewPageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
                            shrinkWrap: true,
                            itemCount: recentList.length,
                            itemBuilder: (context, i) {
                              final recentUser = recentList[i];
                              return UserListItem(userUid: recentUser.uid);
                            });
                      },
                    ),
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
