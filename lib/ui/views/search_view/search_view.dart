import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/dule/dule_view.dart';
import 'package:hint/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';

import 'search_viewmodel.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  AppBar buildSearchHeader(BuildContext context, SearchViewModel model) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(FeatherIcons.arrowLeft),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      title: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Hero(
          tag: 'search',
          child: CupertinoTextField.borderless(
            autofocus: true,
            textInputAction: TextInputAction.search,
            controller: model.searchTech,
            padding: const EdgeInsets.all(8.0),
            placeholder: 'Search for someone',
            suffix: model.searchTech.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () => model.searchTech.clear(),
                    icon: const Icon(
                      FeatherIcons.x,
                      color: AppColors.inActiveGray,
                    )),
            placeholderStyle: TextStyle(color: Colors.indigo.shade900),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              border: Border.all(color: CupertinoColors.lightBackgroundGray),
              borderRadius: BorderRadius.circular(12.0),
            ),
            onChanged: (value) {
              model.handleUsernameSearch(value);

              model.updateSearchEmpty();
            },
          ),
        ),
      ),
      titleSpacing: 0,
    );
  }

  Widget buildEmptySearch(String query) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(
              FeatherIcons.atSign,
              size: 128.0,
              color: CupertinoColors.inactiveGray,
            ),
          ),
          Text(
            'Sorry, nothing found.\nTry searching for another \n$query.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
                fontSize: 24.0),
          )
        ],
      ),
    );
  }

  Widget buildInitialContent(SearchViewModel model) {
    bool isSearchListEmpty = Hive.box(HiveApi.recentSearchesHiveBox).isEmpty;
    return CustomScrollView(
      slivers: [
        sliverVerticalSpaceRegular,
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  isSearchListEmpty ? 'No Recent Searches' : 'Recent Searches',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20),
                )
              ],
            ),
          ),
        ),
        sliverVerticalSpaceRegular,
        ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.recentSearchesHiveBox),
          builder: (context, box, child) {
            final recentSearchList = box.values.toList();
            return SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
              final recentSearch = recentSearchList[i];
              return Row(
                children: [
                  Expanded(child: UserListItem(userUid: recentSearch)),
                  IconButton(
                    onPressed: () {
                      model.deleteFromRecentSearches(recentSearch);
                    },
                    icon: const Icon(FeatherIcons.x),
                    color: Colors.black54,
                  ),
                  horizontalSpaceSmall,
                ],
              );
            }, childCount: recentSearchList.length));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      onDispose: (model) {
        model.searchTech.dispose();
      },
      builder: (context, model, child) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: buildSearchHeader(context, model),
          body: FutureBuilder<QuerySnapshot>(
            future: model.usernameSearchFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return buildInitialContent(model);
              }
              final searchResults = snapshot.data!.docs;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  snapshot.data != null && searchResults.isNotEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) {
                              var fireUser =
                                  FireUser.fromFirestore(searchResults[index]);
                              return UserItem(
                                fireUser: fireUser,
                                title: fireUser.username,
                                onTap: () async {
                                  String liveUserUid =
                                      AuthService.liveUser!.uid;
                                  String value = chatService.getConversationId(
                                      fireUser.id, liveUserUid);
                                  navService.cupertinoPageRoute(
                                      context, DuleView(fireUser: fireUser));
                                  await databaseService.updateUserDataWithKey(
                                      DatabaseMessageField.roomUid, value);
                                  model.addToRecentSearches(fireUser.id);
                                },
                              );
                            },
                            childCount: searchResults.length,
                          ),
                        )
                      : SliverToBoxAdapter(child: buildEmptySearch('username')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
