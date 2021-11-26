import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {

  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  static final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

  void handleSearch(String query) {
    Future<QuerySnapshot>? searchResults = usersCollection
        .where(
          'display',
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }

  void onUserItemTap(BuildContext context, FireUser fireUser) {
  }
}