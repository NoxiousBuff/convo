import 'package:cloud_firestore/cloud_firestore.dart';
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

  // RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<QuerySnapshot>? _peopleSuggestionsFuture;
  Future<QuerySnapshot>? get peopleSuggestionsFuture =>
      _peopleSuggestionsFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  final usersInterests =
      hiveApi.getUserData(FireUserField.interests) as List<dynamic>;

  void updateTodaysInterestsList() {
    var randomPicker =
        List<int>.generate(usersInterests.length - 1, (i) => i + 1)..shuffle();
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
      usersInterests[random1],
      usersInterests[random2],
      usersInterests[random3],
      usersInterests[random4],
      usersInterests[random5],
      usersInterests[random6],
      usersInterests[random7],
      usersInterests[random8],
      usersInterests[random9],
      usersInterests[random10],
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
        defaultValue: usersInterests.sublist(0, 9)) as List<dynamic>;
    Future<QuerySnapshot>? searchResults = subsCollection
        .where(
          FireUserField.interests,
          arrayContainsAny: searchArray,
        )
        .limit(6)
        .getSavy();
    _peopleSuggestionsFuture = searchResults;
    notifyListeners();
  }
}
