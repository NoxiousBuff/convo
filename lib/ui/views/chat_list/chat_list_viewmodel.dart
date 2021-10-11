import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';
import 'package:stacked/stacked.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final bool _scrollIsOnTop = true;
  bool get scrollIsOnTop => _scrollIsOnTop;
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  ScrollController? scrollController;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

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