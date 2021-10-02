import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel extends FutureViewModel<QuerySnapshot> {
  final bool _scrollIsOnTop = true;
  bool get scrollIsOnTop => _scrollIsOnTop;
  AuthService authService = AuthService();
  ChatService chatService = ChatService();
  late FireUser fireUser;
  ScrollController? scrollController;

  final _currentUser = FirebaseAuth.instance.currentUser;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(usersFirestoreKey);

  Future<void> currentUserDoc() async {
    if (_currentUser != null) {
      final user = await FirebaseFirestore.instance
          .collection(usersFirestoreKey)
          .doc(_currentUser!.uid)
          .get();
      fireUser = FireUser.fromFirestore(user);
      notifyListeners();
    } else {
      getLogger('ChatListViewModel').wtf("user is currently logged out");
    }
  }

  void signOut(BuildContext context) =>
      authService.signOut(context, onSignOut: () {
        getLogger('AuthService').wtf('User has been loggeed out.');
      });

  @override
  Future<QuerySnapshot> futureToRun() => usersCollection.get();
}
