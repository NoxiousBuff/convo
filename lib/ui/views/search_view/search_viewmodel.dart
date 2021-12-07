import 'package:intl/intl.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchViewModel extends BaseViewModel {
  final log = getLogger('SearchViewModel');

  Future<QuerySnapshot>? _usernameSearchFuture;
  Future<QuerySnapshot>? get usernameSearchFuture => _usernameSearchFuture;

  Future<QuerySnapshot>? _emailSearchFuture;
  Future<QuerySnapshot>? get emailSearchFuture => _emailSearchFuture;

  Future<QuerySnapshot>? _displayNameSearchFuture;
  Future<QuerySnapshot>? get displayNameSearchFuture =>
      _displayNameSearchFuture;

  Future<QuerySnapshot>? _interestsSearchFuture;
  Future<QuerySnapshot>? get interestsSearchFuture => _interestsSearchFuture;

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

  /// search the user by its email address
  void handleEmailSearch(String query) {
    var emailQuery = query.toLowerCase();
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.email,
          isGreaterThanOrEqualTo: emailQuery,
          isLessThan: emailQuery.isNotEmpty
              ? emailQuery.substring(0, emailQuery.length - 1) +
                  String.fromCharCode(
                      emailQuery.codeUnitAt(emailQuery.length - 1) + 1)
              : () {},
        )
        .get();
    _emailSearchFuture = searchResults;
    notifyListeners();
  }

  /// search the user by its displayname
  void handleDisplayNameSearch(String query) {
    var displayNameQuery = toBeginningOfSentenceCase(query);
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.displayName,
          isGreaterThanOrEqualTo: displayNameQuery,
          isLessThan: displayNameQuery!.isNotEmpty
              ? displayNameQuery.substring(0, displayNameQuery.length - 1) +
                  String.fromCharCode(
                      displayNameQuery.codeUnitAt(displayNameQuery.length - 1) +
                          1)
              : () {},
        )
        .get();
    _displayNameSearchFuture = searchResults;
    notifyListeners();
  }

  /// search the user by it's interests
  void handleInterestsSearch(String query) {
    try {
      String? interests = toBeginningOfSentenceCase(query);
      log.wtf('Interests:$interests');
      Future<QuerySnapshot>? searchResults = subsCollection
          .where(FireUserField.interests, arrayContains: interests ?? 'Anime')
          .get();
      _interestsSearchFuture = searchResults;
      notifyListeners();
    } catch (e) {
      log.wtf('handleInterestsSearch Error:$e');
    }
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
