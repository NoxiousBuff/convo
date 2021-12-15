import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'search_to_write_letter_viewmodel.dart';

class SearchToWriteLetterView extends StatelessWidget {
  const SearchToWriteLetterView({Key? key}) : super(key: key);

  static const String id = '/SearchToWriteLetterView';

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

  Widget buildInitialContent(SearchToWriteLetterViewModel model) {
    bool isSearchListEmpty = Hive.box(HiveApi.recentSearchesHiveBox).isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpaceRegular,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                isSearchListEmpty ? 'No Recent Searches' : 'Recent Searches',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              )
            ],
          ),
        ),
        verticalSpaceRegular,
        Expanded(
          child: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.recentSearchesHiveBox),
            builder: (context, box, child) {
              final recentSearchList = box.values.toList();
              return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final recentSearch = recentSearchList[i];
                    return Row(
                      children: [
                        Expanded(child: UserListItem(userUid: recentSearch, onTap: (fireUser) {
                          Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WriteLetterView(
                                            fireUser: fireUser)));
                        },)),
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
                  },
                  itemCount: recentSearchList.length);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchToWriteLetterViewModel>.reactive(
      viewModelBuilder: () => SearchToWriteLetterViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: cwAuthAppBar(context,
            title: '', onPressed: () => Navigator.pop(context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceRegular,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: cwEADescriptionTitle(
                  context, 'Choose who would like to write a letter'),
            ),
            verticalSpaceSmall,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: cwEATextField(
                  context, model.searchToWriteLetterTech, 'Search by username',
                  onChanged: (value) {
                model.handleUsernameSearch(value);
              }),
            ),
            verticalSpaceSmall,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            verticalSpaceSmall,
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: model.usernameSearchFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return buildInitialContent(model);
                  }
                  final searchResults = snapshot.data!.docs;
                  return snapshot.data != null && searchResults.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var fireUser =
                                FireUser.fromFirestore(searchResults[index]);
                            return UserItem(
                              fireUser: fireUser,
                              title: fireUser.username,
                              onTap: () async {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WriteLetterView(
                                            fireUser: fireUser)));
                                model.addToRecentSearches(fireUser.id);
                              },
                            );
                          },
                          itemCount: searchResults.length,
                        )
                      : buildEmptySearch('username');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
