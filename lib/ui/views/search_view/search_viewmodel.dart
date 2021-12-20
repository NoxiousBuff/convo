import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchViewModel extends BaseViewModel {
  final log = getLogger('SearchViewModel');

  Future<QuerySnapshot>? _usernameSearchFuture;
  Future<QuerySnapshot>? get usernameSearchFuture => _usernameSearchFuture;

  bool _searchEmpty = true;
  bool get searchEmpty => _searchEmpty;

  TextEditingController searchTech = TextEditingController();

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  void updateSearchEmpty() {
    _searchEmpty = searchTech.text.isEmpty;
    log.wtf(_searchEmpty);
    notifyListeners();
  }

  ///search the user by its username
  void handleUsernameSearch(String query) {
    var usernameQuery = query.toLowerCase();
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.username,
          isGreaterThanOrEqualTo: usernameQuery,
          isLessThan: usernameQuery.isNotEmpty
              ? usernameQuery.substring(0, usernameQuery.length - 1) +
                  String.fromCharCode(
                      usernameQuery.codeUnitAt(usernameQuery.length - 1) + 1)
              : () {},
        )
        .get();
    _usernameSearchFuture = searchResults;
    notifyListeners();
  }

  void addToRecentSearches(String uid) {
    hiveApi.save(HiveApi.recentSearchesHiveBox, uid, uid);
    log.wtf('added');
  }

  void deleteFromRecentSearches(String uid) {
    hiveApi.delete(HiveApi.recentSearchesHiveBox, uid);
    log.wtf('deleted');
  }

  @override
  void dispose() {
    super.dispose();
    searchTech.dispose();
  }
}
