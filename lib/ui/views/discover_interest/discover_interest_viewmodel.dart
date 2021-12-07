import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DiscoverInterestViewModel extends FutureViewModel {
  final log = getLogger('DiscoverInterestViewModel');

  final String interestName;

  DiscoverInterestViewModel({required this.interestName});

  static final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  Future<QuerySnapshot> getSuggestedPeople() async {
    return subsCollection.where(
        FireUserField.interests,
        arrayContains: interestName).get(const GetOptions(source: Source.cache));
  }

  String replaceString() {
    final replacedStr = interestName.replaceAll(RegExp(r"\s\b|\b\s"), '\n');
    return replacedStr;
  }

  @override
  Future futureToRun() {
    return getSuggestedPeople();
  }

}