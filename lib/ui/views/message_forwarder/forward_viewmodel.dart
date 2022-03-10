import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/pods/verify_email_pod.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ForwardViewModel extends StreamViewModel<QuerySnapshot> {
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

  @override
  Stream<QuerySnapshot> get stream => recentChats();
}
