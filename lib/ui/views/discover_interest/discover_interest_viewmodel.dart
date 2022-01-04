import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DiscoverInterestViewModel extends FutureViewModel<QuerySnapshot> {
  final log = getLogger('DiscoverInterestViewModel');

  final String interestName;

  DiscoverInterestViewModel({required this.interestName});

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  Future<QuerySnapshot> getSuggestedPeople() async {
    final String userUid = hiveApi.getUserData(FireUserField.id);
    return subsCollection
        .where(FireUserField.interests, arrayContains: interestName)
        .where(FireUserField.id, isNotEqualTo: userUid)
        .get();
  }

  String replaceString() {
    final replacedStr = interestName.replaceAll(RegExp(r"\s\b|\b\s"), '\n');
    return replacedStr;
  }

  @override
  Future<QuerySnapshot> futureToRun() {
    return getSuggestedPeople();
  }
}
