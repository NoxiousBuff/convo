import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DiscoverInterestViewModel extends BaseViewModel {
  final log = getLogger('DiscoverInterestViewModel');

  final String interestName;

  DiscoverInterestViewModel({required this.interestName});

  String get userUid => hiveApi.getUserData(FireUserField.id);

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  Query<Object?> get suggestedUsers => subsCollection
        .where(FireUserField.interests, arrayContains: interestName)
        .where(FireUserField.id, isNotEqualTo: userUid)
        ;

  String replaceString() {
    final replacedStr = interestName.replaceAll(RegExp(r"\s\b|\b\s"), '\n');
    return replacedStr;
  }
}
