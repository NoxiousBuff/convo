import 'package:hint/api/hive.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/views/profile/profile_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/shared/user_item.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';

import 'search_viewmodel.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  AppBar buildSearchHeader(BuildContext context, SearchViewModel model) {
    final appBarBrightness =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;
    final systemUIOverlay =
        SystemUiOverlayStyle(statusBarIconBrightness: appBarBrightness);
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(FeatherIcons.arrowLeft),
        color: Theme.of(context).colorScheme.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      systemOverlayStyle: systemUIOverlay,
      title: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Hero(
          tag: 'search',
          child: CupertinoTextField.borderless(
            focusNode: model.searchFocusNode,
            autofocus: true,
            textInputAction: TextInputAction.search,
            controller: model.searchTech,
            padding: const EdgeInsets.all(8.0),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.black,
              fontWeight: FontWeight.w400,
            ),
            placeholder: 'Search for someone',
            placeholderStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.mediumBlack,
              fontWeight: FontWeight.w400,
            ),
            suffix: model.searchTech.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () => model.searchTech.clear(),
                    icon: Icon(
                      FeatherIcons.x,
                      color: Theme.of(context).colorScheme.mediumBlack,
                    )),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.lightGrey,
              border: Border.all(color: Theme.of(context).colorScheme.grey),
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

  Widget buildEmptySearch(BuildContext context, String query) {
    return Center(
        child: Column(
      children: [
        verticalSpaceLarge,
        emptyState(context,
            emoji: '😞',
            description: 'Perhaps try again with another username.',
            heading: 'Nothing found for \n\'$query\'.'),
      ],
    ));
  }

  Widget buildInitialContent(BuildContext context, SearchViewModel model) {
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
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.mediumBlack,
                  ),
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
                  Expanded(child: UserListItem(userUid: recentSearch, onTap: (fireUser) => navService.cupertinoPageRoute(context, ProfileView(fireUser: fireUser)))),
                  IconButton(
                    onPressed: () {
                      model.deleteFromRecentSearches(recentSearch);
                    },
                    icon: const Icon(FeatherIcons.x),
                    color: Theme.of(context).colorScheme.mediumBlack,
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
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: buildSearchHeader(context, model),
        body: FutureBuilder<QuerySnapshot>(
          future: model.usernameSearchFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildInitialContent(context, model);
            }
            final searchResults = snapshot.data!.docs;
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              subtitle: fireUser.displayName,
                              onTap: () {
                                navService.cupertinoPageRoute(context, ProfileView(fireUser: fireUser));
                                model.addToRecentSearches(fireUser.id);
                              },
                            );
                          },
                          childCount: searchResults.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: buildEmptySearch(context, model.searchTech.text),
                      ),
                sliverVerticalSpaceMedium,
                searchResults.length >= 25
                    ? SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Type More to Get Better Results',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.black),
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(child: shrinkBox),
              ],
            );
          },
        ),
      ),
    );
  }
}
