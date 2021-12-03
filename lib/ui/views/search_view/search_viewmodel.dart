import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  final log = getLogger('SearchViewModel');

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

  void handleSearch(String query) {
    final localQuery = query.toLowerCase();
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.username,
          isGreaterThanOrEqualTo: localQuery,
          isLessThan: localQuery.isNotEmpty ? localQuery.substring(0, localQuery.length - 1) +
              String.fromCharCode(
                  localQuery.codeUnitAt(localQuery.length - 1) + 1) : (){},
        )
        .get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }

  void addToRecentSearches(String uid) {
    hiveApi.saveInHive(HiveApi.recentSearchesHiveBox, uid, uid);
    log.wtf('added');
  }

  void deleteFromRecentSearches(String uid) {
    hiveApi.deleteInHive(HiveApi.recentSearchesHiveBox, uid);
    log.wtf('deleted');
  }

  void onUserItemTap(BuildContext context, FireUser fireUser) {}

  @override
  void dispose() {
    super.dispose();
    searchTech.dispose();
  }
}
