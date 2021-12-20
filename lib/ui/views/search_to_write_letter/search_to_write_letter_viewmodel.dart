import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class SearchToWriteLetterViewModel extends BaseViewModel {
  final log = getLogger('SearchToWriteLetterViewModel');

  final TextEditingController searchToWriteLetterTech = TextEditingController(text: '');

  Future<QuerySnapshot>? _usernameSearchFuture;
  Future<QuerySnapshot>? get usernameSearchFuture => _usernameSearchFuture;

  bool _searchEmpty = true;
  bool get searchEmpty => _searchEmpty;

  void updateSearchEmpty() {
    _searchEmpty = searchToWriteLetterTech.text.isEmpty;
    log.wtf(_searchEmpty);
    notifyListeners();
  }

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

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
}