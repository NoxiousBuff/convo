import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';
import 'package:hint/ui/views/dule/dule_view.dart';
import 'package:stacked/stacked.dart';

import 'search_viewmodel.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  static final TextEditingController searchTech = TextEditingController();

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
            controller: searchTech,
            padding: const EdgeInsets.all(8.0),
            placeholder: 'Search for someone',
            placeholderStyle: TextStyle(color: Colors.indigo.shade900),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              border: Border.all(color: CupertinoColors.lightBackgroundGray),
              borderRadius: BorderRadius.circular(12.0),
            ),
            onChanged: (value) {
              model.handleSearch(value);
            },
          ),
        ),
      ),
      titleSpacing: 0,
    );
  }

  Widget buildSearchContent(BuildContext context, SearchViewModel model) {
    return FutureBuilder<QuerySnapshot>(
      future: model.searchResultFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final searchResults = snapshot.data!.docs;
        return searchResults.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: searchResults.length,
                itemBuilder: (context, i) {
                  FireUser localFireUser =
                      FireUser.fromFirestore(snapshot.data!.docs[i]);
                  return UserItem(
                    fireUser: localFireUser,
                    onTap: () async {
                      String liveUserUid = AuthService.liveUser!.uid;
                      String value = chatService.getConversationId(
                          localFireUser.id, liveUserUid);
                      navService.cupertinoPageRoute(
                          context, DuleView(fireUser: localFireUser));
                      await databaseService.updateUserDataWithKey(
                          DatabaseMessageField.roomUid, value);
                    },
                  );
                },
              )
            : buildEmptySearch();
      },
    );
  }

  Widget buildEmptySearch() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(
              FeatherIcons.atSign,
              size: 128.0,
              color: CupertinoColors.inactiveGray,
            ),
          ),
          Text(
            'Sorry, nothing found.\nTry searching for another \nusername.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
                fontSize: 24.0),
          )
        ],
      ),
    );
  }

  Widget buildInitialContent() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(
              FeatherIcons.smile,
              size: 128.0,
              color: CupertinoColors.inactiveGray,
            ),
          ),
          Text(
            'Need to search for someone...huh??',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
                fontSize: 24.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: buildSearchHeader(context, model),
          body: model.searchResultFuture != null
              ? buildSearchContent(context, model)
              : Container()),
    );
  }
}
