import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';

class DiscoverViewModel extends BaseViewModel {
  final log = getLogger('DiscoverViewModel');

  Future<QuerySnapshot>? _searchResultFuture;
  Future<QuerySnapshot>? get searchResultFuture => _searchResultFuture;

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

    final usersInterests = hiveApi.getFromHive(HiveApi.userdataHiveBox, FireUserField.interests) as List<dynamic>;
  void peopleSuggestions() {
    Future<QuerySnapshot>? searchResults = subsCollection.where(
        FireUserField.username,
        arrayContainsAny: usersInterests.sublist(0,9)).get();
    _searchResultFuture = searchResults;
    notifyListeners();
  }
}