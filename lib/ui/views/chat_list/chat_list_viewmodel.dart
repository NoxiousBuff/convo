import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ChatListViewModel');

  Stream<QuerySnapshot> recentChats() {
    return FirebaseFirestore.instance
        .collection(subsFirestoreKey)
        .doc(AuthService.liveUser!.uid)
        .collection(recentFirestoreKey)
        .orderBy(RecentUserField.timestamp, descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  @override
  Stream<QuerySnapshot> get stream => recentChats();
}
