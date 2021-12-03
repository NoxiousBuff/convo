import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:stacked/stacked.dart';

class UserListItemViewModel extends FutureViewModel<DocumentSnapshot> {
  final String userUinqueUid;

  UserListItemViewModel(this.userUinqueUid);

  @override
  Future<DocumentSnapshot> futureToRun() => FirebaseFirestore.instance
      .collection(subsFirestoreKey)
      .doc(userUinqueUid)
      .get(const GetOptions(source: Source.cache));
}