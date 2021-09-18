import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:stacked/stacked.dart';

class ChatListViewModel extends FutureViewModel<QuerySnapshot> {
  final bool _scrollIsOnTop = true;
  bool get scrollIsOnTop => _scrollIsOnTop;
  AuthService authService = AuthService();
  ChatService chatService = ChatService();

  ScrollController? scrollController;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

  void signOut(BuildContext context) => authService.signOut(context,onSignOut:  () {
                getLogger('AuthService').wtf('User has been loggeed out.');
              });

  @override
  Future<QuerySnapshot> futureToRun() => usersCollection.get();
}