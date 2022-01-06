import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/query.dart';
import 'package:stacked/stacked.dart';

class DiscoverViewModel extends BaseViewModel {
  final log = getLogger('DiscoverViewModel');

  final discoverRefreshKey = GlobalKey<RefreshIndicatorState>();

  Future<QuerySnapshot>? _peopleSuggestionsFuture;
  Future<QuerySnapshot>? get peopleSuggestionsFuture =>
      _peopleSuggestionsFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  final _usersInterests =
      hiveApi.getUserData(FireUserField.interests,defaultValue: []) as List<dynamic>;

  List<dynamic> get userInterests => _usersInterests;

  void onRefresh() {
    updateListIndices();
    updateTodaysInterestsList();
    peopleSuggestions();
  }

  void updateTodaysInterestsList() {
    var randomPicker =
        List<int>.generate(_usersInterests.length - 1, (i) => i + 1)..shuffle();
    int random1 = randomPicker.removeLast();
    int random2 = randomPicker.removeLast();
    int random3 = randomPicker.removeLast();
    int random4 = randomPicker.removeLast();
    int random5 = randomPicker.removeLast();
    int random6 = randomPicker.removeLast();
    int random7 = randomPicker.removeLast();
    int random8 = randomPicker.removeLast();
    int random9 = randomPicker.removeLast();
    int random10 = randomPicker.removeLast();

    final List<String> randomList = [
      _usersInterests[random1],
      _usersInterests[random2],
      _usersInterests[random3],
      _usersInterests[random4],
      _usersInterests[random5],
      _usersInterests[random6],
      _usersInterests[random7],
      _usersInterests[random8],
      _usersInterests[random9],
      _usersInterests[random10],
    ];
    hiveApi.saveAndReplace(HiveApi.appSettingsBoxName,
        AppSettingKeys.todaysInterestsList, randomList);
    notifyListeners();
  }

  void updateListIndices() {
    var randomPicker = List<int>.generate(20, (i) => i + 1)..shuffle();
    int random1 = randomPicker.removeLast();
    int random2 = randomPicker.removeLast();
    assert(random1 != random2);
    hiveApi.saveAndReplace(
        HiveApi.appSettingsBoxName, AppSettingKeys.firstListIndex, random1);
    hiveApi.saveAndReplace(
        HiveApi.appSettingsBoxName, AppSettingKeys.secondListIndex, random2);
  }

  Future<void> peopleSuggestions() async {
    final searchArray = await hiveApi.getFromHive(
        HiveApi.appSettingsBoxName, AppSettingKeys.todaysInterestsList,
        defaultValue: _usersInterests.sublist(0, 9)) as List<dynamic>;
    final id = FirebaseAuth.instance.currentUser!.uid;
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.interests,
          arrayContainsAny: searchArray,
        )
        .where(
          FireUserField.id,
          isNotEqualTo: id,
        )
        .limit(6)
        .getSavy();
    _peopleSuggestionsFuture = searchResults;
    notifyListeners();
  }
}
