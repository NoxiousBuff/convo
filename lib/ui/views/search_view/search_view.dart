import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/views/chat_list/widgets/user_item.dart';
import 'package:stacked/stacked.dart';

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
      flexibleSpace: Container(color: Colors.grey.shade100,),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      title: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Hero(
          tag: 'search',
          child: CupertinoTextField.borderless(
            textInputAction: TextInputAction.search,
            focusNode: model.searchFocusNode,
            controller: model.searchTech,
            padding: const EdgeInsets.all(8.0),
            placeholder: 'Search for someone',
            placeholderStyle: TextStyle(color: Colors.grey.shade900),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              // border: Border.all(color: CupertinoColors.lightBackgroundGray),
              borderRadius: BorderRadius.circular(12.0),
            ),
            onChanged: (value) {
              model.updateSearchEmpty();
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
        Widget child;
        if (!snapshot.hasData) {
          child = const Center(child: CupertinoActivityIndicator());
        }
        
        final searchResults = snapshot.data;
        if(searchResults == null) {
          child = buildEmptySearch();
        }
        if (searchResults != null && searchResults.docs.isNotEmpty) {
          child = ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: searchResults.docs.length,
            itemBuilder: (context, i) {
              FireUser localFireUser =
                  FireUser.fromFirestore(snapshot.data!.docs[i]);
              return UserItem(
                fireUser: localFireUser,
                onTap: ()  {
                  chatService.startDuleConversation(context, localFireUser);
                },
              );
            },
          );
        } 
        
        if (model.searchEmpty) {
          child = buildDefaultContent();
        } else {
          child = CircularProgressIndicator();
        }
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 100), child: child);
      },
    );
  }

  Widget buildDefaultContent() {
    return const Text('fbsef');
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      onModelReady: (model) {
        model.searchFocusNode.requestFocus();
      },
      builder: (context, model, child) => Scaffold(
        appBar: buildSearchHeader(context, model),
        body: buildSearchContent(context, model),
      ),
    );
  }
}
