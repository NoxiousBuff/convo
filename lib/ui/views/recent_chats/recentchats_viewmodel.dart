import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class RecentChatsViewModel extends StreamViewModel {
  final liveUserUid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getRecentChats() {
    return _firestore
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }


  void signOut(BuildContext context) =>
      authService.signOut(context, onSignOut: () {
        getLogger('AuthService').wtf('User has been loggeed out.');
      });

  @override
 Stream<QuerySnapshot<Object?>> get stream  => getRecentChats();
}
