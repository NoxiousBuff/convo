import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/pods/verify_email_pod.dart';
import 'package:hint/services/auth_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ChatListViewModel');

  final verifyEmailStatusLocator = locator<VerifyEmailStatus>();

  bool get isEmailVerified => FirebaseAuth.instance.currentUser!.emailVerified;

  String get userUid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> recentChats() {
    return FirebaseFirestore.instance
        .collection(subsFirestoreKey)
        .doc(AuthService.liveUser!.uid)
        .collection(recentFirestoreKey)
        .orderBy(RecentUserField.timestamp, descending: true)
        .snapshots();
  }

  void invitePeople() {
    String username =
        hiveApi.getUserData(FireUserField.username, defaultValue: '');
    Share.share(
        'I am on Convo as @$username. We can chat realtime and it\'s super immersive. Install the app to connect with me. \n$appPLayStoreUrl');
  }

  @override
  Stream<QuerySnapshot> get stream => recentChats();
}
