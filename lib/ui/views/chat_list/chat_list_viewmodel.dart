import 'package:flutter/material.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ChatListViewModel');
  ScrollController? scrollController;
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

    Future<void> setStatus({required String status}) async {
    await _firestore
        .collection(usersFirestoreKey)
        .doc(_auth.currentUser!.uid)
        .update({
      "status": status,
      "lastSeen": Timestamp.now(),
    }).catchError((e) => log.e(e));
  }

  final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  void signOut(BuildContext context) =>
      authService.signOut(context, onSignOut: () {
        getLogger('AuthService').wtf('User has been loggeed out.');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const EmailRegisterView()),
            (route) => false);
      });

  @override
  Stream<QuerySnapshot<Object?>> get stream => chatService.getRecentChatList();
}