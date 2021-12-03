import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/empty_list_ui.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/archives/archives_view.dart';
import 'package:hint/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final log = getLogger('ChatListView');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        final data = model.data;
        if (model.hasError) {
          return const Center(
            child: Text('Model has Error'),
          );
        }
        if (!model.dataReady) {
          return const Center(child: CircularProgressIndicator());
        }
        if (data != null) {
          final docs = data.docs;
          return Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverNavigationBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: buildEmptyListUi(context),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(subsFirestoreKey)
                            .doc(AuthService.liveUser!.uid)
                            .collection(archivesFirestorekey)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final archiveData = snapshot.data;
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Archive Has Error'),
                            );
                          }
                          if (archiveData != null) {
                            final archiveDocs = archiveData.docs;
                            return archiveDocs.isNotEmpty
                                ? ListTile(
                                    onTap: () {
                                      navService.cupertinoPageRoute(
                                          context, const ArchiveView());
                                    },
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      maxRadius: 30,
                                      child: Icon(
                                        CupertinoIcons.archivebox_fill,
                                        color: AppColors.blue,
                                        size: 30,
                                      ),
                                    ),
                                    title: Text(
                                      'Archive',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(
                        height: screenHeight(context),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: docs.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, i) {
                                final doc = docs[i];
                                final uid = doc[RecentUserField.userUid];
                                bool pinned = doc[RecentUserField.pinned];
                                return pinned
                                    ? GestureDetector(
                                        onLongPress: () =>
                                            model.showTileOptions(
                                                uid, context, pinned),
                                        child: UserListItem(
                                            userUid: uid, pinned: pinned))
                                    : const SizedBox.shrink();
                              },
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: docs.length,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, i) {
                                final doc = docs[i];
                                final uid = doc[RecentUserField.userUid];
                                bool archive = doc[RecentUserField.archive];
                                bool pinned = doc[RecentUserField.pinned];

                                return archive
                                    ? const SizedBox.shrink()
                                    : pinned
                                        ? const SizedBox.shrink()
                                        : GestureDetector(
                                            onLongPress: () =>
                                                model.showTileOptions(
                                                    uid, context, pinned),
                                            child: UserListItem(
                                              userUid: uid,
                                              pinned: pinned,
                                            ),
                                          );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Data Is Null');
        }
      },
    );
  }
}