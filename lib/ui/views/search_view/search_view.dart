
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';
import 'package:hint/ui/views/search_view/search_viewmodel.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  static final TextEditingController searchTech = TextEditingController();

  AppBar buildSearchHeader(BuildContext context, SearchViewModel model) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
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

  Widget allUsersList(BuildContext context, SearchViewModel model) {
    final searchFuture =
        FirebaseFirestore.instance.collection(usersFirestoreKey).get();
    return FutureBuilder<QuerySnapshot>(
      future: searchFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final data = snapshot.data;
        if (data != null) {
          final searchResults = data.docs;

          return searchResults.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, i) {
                    FireUser localFireUser =
                        FireUser.fromFirestore(data.docs[i]);
                    return UserItem(
                      randomColor: randomColor,
                      fireUser: localFireUser,
                      onTap: () => model.onUserItemTap(context, localFireUser),
                    );
                  },
                )
              : buildEmptySearch();
        } else {
          return buildEmptySearch();
        }
      },
    );
  }

  Widget searchedUser(BuildContext context, SearchViewModel model) {
    return FutureBuilder<QuerySnapshot>(
      future: model.searchResultFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final data = snapshot.data;
        if (data != null) {
          final searchResults = data.docs;

          return searchResults.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, i) {
                    FireUser localFireUser =
                        FireUser.fromFirestore(data.docs[i]);
                    return UserItem(
                      randomColor: randomColor,
                      fireUser: localFireUser,
                      onTap: () => model.onUserItemTap(context, localFireUser),
                    );
                  },
                )
              : buildEmptySearch();
        } else {
          return buildEmptySearch();
        }
      },
    );
  }

  Widget buildEmptySearch() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Icon(
                Icons.icecream,
                size: 128.0,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            Text(
              'Sorry, nothing found.\nMay be we can interest you in \nIceCream.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w300,
                  fontSize: 24.0),
            )
          ],
        ),
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
              Icons.face_unlock_sharp,
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
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 20),
              child: Container(
                margin: const EdgeInsets.only(bottom: 1),
                child: CupertinoTextField(
                  placeholder: 'Search Friends',
                  cursorColor: systemBackground,
                  onChanged: (val) {
                    model.handleSearch(val);
                  },
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: systemBackground),
                  placeholderStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: systemBackground),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: model.searchResultFuture != null
              ? searchedUser(context, model)
              : allUsersList(context, model),
        );
      },
    );
  }
}

//  model.searchResultFuture != null
//               ? buildSearchContent(context, model)
//               : Container()
