import 'dart:developer';
import 'package:hint/app/app.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/extensions/query.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/archives/archives_view.dart';
import 'package:hint/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hint/ui/views/flutter_downloader/downloader_view.dart';

import 'widgets/show_tile_options.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  CupertinoSliverNavigationBar _buildAppBar(
          BuildContext context, ChatListViewModel model) =>
      CupertinoSliverNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () =>
              navService.materialPageRoute(context, const DownloaderView()),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/appicon_mdpi_gradient.png'),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              borderRadius: BorderRadius.circular(16),
              color: Colors.transparent,
              child: IconButton(
                color: Theme.of(context).colorScheme.black,
                iconSize: 24,
                icon: const Icon(FeatherIcons.userPlus),
                onPressed: () {
                  model.invitePeople();
                },
              ),
            ),
            ValueListenableBuilder<Box>(
                valueListenable:
                    hiveApi.hiveStream(HiveApi.archivedUsersHiveBox),
                builder: (context, archivedUsersBox, child) {
                  final archivedUsersList = archivedUsersBox.values.toList();
                  return archivedUsersList.isEmpty
                      ? const SizedBox.shrink()
                      : Material(
                          color: Colors.transparent,
                          child: IconButton(
                            color: Theme.of(context).colorScheme.black,
                            iconSize: 24,
                            icon: const Icon(FeatherIcons.folder),
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
                color: Theme.of(context).colorScheme.black,
                icon: const Icon(FeatherIcons.send),
                iconSize: 24,
                onPressed: () {
                  mainViewPageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
              ),
            ),
          ],
        ),
        stretch: true,
       
        // *  Title of the app
        largeTitle: Text(
          'Convo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.black,
          ),
        ),
        border: Border.all(width: 0.0, color: Colors.transparent),
      );

  Widget _buildPinnedList(BuildContext context, ChatListViewModel model) =>
      ValueListenableBuilder<Box>(
        valueListenable: hiveApi.hiveStream(HiveApi.pinnedUsersHiveBox),
        builder: (context, pinnedUsersBox, child) {
          final pinnedUsersList = pinnedUsersBox.values.toList();
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent:
                    screenWidthPercentage(context, percentage: 0.35),
                maxCrossAxisExtent:
                    screenWidthPercentage(context, percentage: 0.4),
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final userUid = pinnedUsersList[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection(subsFirestoreKey)
                          .doc(userUid)
                          .getSavy(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data != null) {
                          final fireUser = FireUser.fromFirestore(data);
                          return InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onLongPress: () {
                              showTileOptions(fireUser, context, true);
                            },
                            onTap: () => chatService.startDuleConversation(
                                context, fireUser),
                            child: Column(
                              children: [
                                UserProfilePhoto(
                                  fireUser.photoUrl,
                                  height: screenWidthPercentage(context,
                                      percentage: 0.25),
                                  width: screenWidthPercentage(context,
                                      percentage: 0.25),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                verticalSpaceSmall,
                                Text(
                                  fireUser.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator.adaptive();
                        }
                      });
                },
                childCount: pinnedUsersList.length,
              ),
            ),
          );
        },
      );

  Widget _buildChatList(BuildContext context, ChatListViewModel model) =>
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        sliver: Builder(
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
                  child: Center(child: CircularProgress()));
            }
            if (data != null) {
              return data.docs.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final doc = data.docs[index];
                          final userUid = doc[RecentUserField.userUid];
                          final archived = doc[RecentUserField.archive];
                          final pinned = doc[RecentUserField.pinned];
                          final String currentUserUid =
                              hiveApi.getUserData(FireUserField.id);
                          return GestureDetector(
                            onLongPress: () {
                              showTileOptions(userUid, context, false);
                            },
                            child: userUid != currentUserUid
                                ? archived || pinned
                                    ? const SizedBox.shrink()
                                    : UserListItem(
                                        onTap: (fireUser) {
                                          chatService.startDuleConversation(
                                              context, fireUser);
                                        },
                                        // contentPadding: const EdgeInsets.all(0),
                                        userUid: userUid,
                                        onLongPress: (fireUser) {
                                          showTileOptions(
                                              fireUser, context, pinned);
                                        },
                                      )
                                : shrinkBox,
                          );
                        },
                        childCount: data.docs.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: emptyState(context,
                          lowerGap:
                              screenHeightPercentage(context, percentage: 0.2),
                          upperGap:
                              screenHeightPercentage(context, percentage: 0.2),
                          emoji: '🙂',
                          heading:
                              'It\'s pretty quiet in here\ndon\'t you think?',
                          description: 'Find friends to begin a\nconversation.',
                          proceedButton: CWAuthProceedButton(
                            buttonTitle: 'Invite Friends Over',
                            onTap: () => model.invitePeople(),
                          ),
                          secondaryButton: TextButton(
                              onPressed: () => mainViewTabController.index = 2,
                              child: const Text('Or Discover Friends'))),
                    );
            } else {
              return const SliverToBoxAdapter(
                child: Text('Data is null'),
              );
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          body: CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            slivers: [
              _buildAppBar(context, model),
              sliverVerticalSpaceRegular,
              _buildPinnedList(context, model),
              _buildChatList(context, model),
            ],
          ),
        );
      },
    );
  }
}
