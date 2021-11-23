import 'package:hint/constants/app_strings.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/live_chat/live_chat.dart';
import 'package:hint/ui/views/search_view/search_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchViewModel extends BaseViewModel {
  final _firestore = FirebaseFirestore.instance;
  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

  void handleSearch(String query) {
    Future<QuerySnapshot>? searchResults = userCollection
        .where(
          UserField.username,
          isGreaterThanOrEqualTo:
              query.toLowerCase().contains(query.toLowerCase()),
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }

  void onUserItemTap(BuildContext context, FireUser fireUser) {
    Navigator.push(
      context,
      cupertinoTransition(
        enterTo: DuleView(fireUser: fireUser),
        exitFrom: const SearchView(),
      ),
    );
  }

  Future<QuerySnapshot> allUsers() {
    return _firestore.collection(usersFirestoreKey).get();
  }
}
