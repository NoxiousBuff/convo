import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/recent_user.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';

import 'chat_list_viewmodel.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final log = getLogger('ChatListView');
  late final FireUser currentFireUser;
  final ChatListViewModel model = ChatListViewModel();

  @override
  void initState() {
    getFireUser();
    super.initState();
  }

  Future<void> getFireUser() async {
    final firebaseUser = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(AuthService.liveUser!.uid)
        .get();
    final fireUser = FireUser.fromFirestore(firebaseUser);
    setState(() {
      currentFireUser = fireUser;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          navService.materialPageRoute(
                            context,
                            DistantView(
                              currentFireUser: currentFireUser,
                            ),
                          );
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.send),
                        onPressed: () {
                          navService.materialPageRoute(
                            context,
                            DistantView(
                              currentFireUser: currentFireUser,
                            ),
                          );
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
}
