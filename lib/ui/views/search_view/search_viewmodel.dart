import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  void handleSearch(String query) {
    final localQuery = query.toLowerCase();
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.username,
          isGreaterThanOrEqualTo: localQuery,
          isLessThan: localQuery.substring(0, localQuery.length - 1) +
              String.fromCharCode(
                  localQuery.codeUnitAt(localQuery.length - 1) + 1),
        )
        .get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }

  void onUserItemTap(BuildContext context, FireUser fireUser) {}
}
