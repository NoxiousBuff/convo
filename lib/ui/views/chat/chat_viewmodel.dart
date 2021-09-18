import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends StreamViewModel<QuerySnapshot> {
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;

  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  ScrollController? scrollController;
  final focusNode = FocusNode();

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<QuerySnapshot> getChats(String conversationId) {
    return conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .orderBy(
          'timestamp',
          descending: true
        )
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getChats(conversationId);
}