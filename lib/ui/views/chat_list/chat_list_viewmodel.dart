import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ChatListViewModel');
  ScrollController? scrollController;
  final AuthService authService = AuthService();

  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection(usersFirestoreKey)
      .doc(AuthService.liveUser!.uid)
      .collection(recentFirestoreKey);

  final CollectionReference subsCollection =
      FirebaseFirestore.instance.collection(subsFirestoreKey);

  void signOut(BuildContext context) => authService.signOut(context);

  @override
  Stream<QuerySnapshot<Object?>> get stream => usersCollection.snapshots();
}
