import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hint/ui/views/archives/archives_view.dart';
import 'package:hint/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(FeatherIcons.userPlus),
                        onPressed: () {
                          log(Hive.box(HiveApi.pinnedUsersHiveBox)
                              .values
                              .toString());
                        },
                      ),
                    ),
                    ValueListenableBuilder<Box>(
                        valueListenable:
                            hiveApi.hiveStream(HiveApi.archivedUsersHiveBox),
                        builder: (context, archivedUsersBox, child) {
                          final archivedUsersList =
                              archivedUsersBox.values.toList();
                          return archivedUsersList.isEmpty
                              ? const SizedBox.shrink()
                              : Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: const Icon(FeatherIcons.archive),
                                    onPressed: () {
                                      navService.cupertinoPageRoute(
                                          context, const ArchiveView());
                                    },
                                  ),
                                );
                        }),
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
              ValueListenableBuilder<Box>(
                valueListenable: hiveApi.hiveStream(HiveApi.pinnedUsersHiveBox),
                builder: (context, pinnedUsersBox, child) {
                  final pinnedUsersList = pinnedUsersBox.values.toList();
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          screenWidthPercentage(context, percentage: 0.4),
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final userUid = pinnedUsersList[index];
                        return FutureBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance
                                .collection(subsFirestoreKey)
                                .doc(userUid)
                                .get(const GetOptions(source: Source.cache)),
                            builder: (context, snapshot) {
                              final data = snapshot.data;
                              if (data != null) {
                                final fireUser = FireUser.fromFirestore(data);
                                return GestureDetector(
                                  onTap: () {
                                    model.showTileOptions(
                                        userUid, context, true);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: SizedBox(
                                            height: screenWidthPercentage(
                                                context,
                                                percentage: 0.25),
                                            width: screenWidthPercentage(
                                                context,
                                                percentage: 0.25),
                                            child: CachedNetworkImage(
                                              imageUrl : fireUser.photoUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                          fireUser.displayName,
                                          style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                            });
                      },
                      childCount: pinnedUsersList.length,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final data = model.data;
                  if (model.hasError) {
                    log(model.error().toString());
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('Model has Error'),
                      ),
                    );
                  }
                  if (!model.dataReady) {
                    return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (data != null) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final doc = data.docs[index];
                        final userUid = doc[RecentUserField.userUid];
                        final archived = doc[RecentUserField.archive];
                        final pinned = doc[RecentUserField.pinned];
                        return GestureDetector(
                          onLongPress: () {
                            model.showTileOptions(userUid, context, false);
                          },
                          child: archived || pinned
                              ? const SizedBox.shrink()
                              : UserListItem(userUid: userUid),
                          // child: UserListItem(userUid: userUid),
                        );
                      }, childCount: data.docs.length),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Text('Data is null'),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
