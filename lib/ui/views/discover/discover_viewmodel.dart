import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';

class DiscoverViewModel extends BaseViewModel {
  final log = getLogger('DiscoverViewModel');

  Future<QuerySnapshot>? _peopleSuggestionsFuture;
  Future<QuerySnapshot>? get peopleSuggestionsFuture => _peopleSuggestionsFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  final usersInterests = hiveApi.getUserDataWithHive(FireUserField.interests);

  void peopleSuggestions() {
    Future<QuerySnapshot>? searchResults = subsCollection.where(
        FireUserField.interests,
        arrayContainsAny: usersInterests.sublist(0,9)).limit(6).get();
    _peopleSuggestionsFuture = searchResults;
    notifyListeners();
  }

  void addToSavedPeople(String uid) {
    hiveApi.saveInHive(HiveApi.savedPeopleHiveBox, uid, uid);
    log.wtf('added');
  }

  void deleteFromSavedPeople(String uid) {
    hiveApi.deleteInHive(HiveApi.savedPeopleHiveBox, uid);
    log.wtf('deleted');
  }
}