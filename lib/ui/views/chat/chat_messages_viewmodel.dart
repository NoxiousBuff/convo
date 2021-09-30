import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessagesViewModel extends StreamViewModel<QuerySnapshot> {
  ChatMessagesViewModel({required this.conversationId, });

  final FirebaseAuth _auth = FirebaseAuth.instance;


  String conversationId;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<QuerySnapshot> getChats(String conversationId) {
    final unreadMsges = conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isNotEqualTo: _auth.currentUser!.uid)
        .where(DocumentField.isRead, isEqualTo: false)
        .snapshots();
    return unreadMsges;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getChats(conversationId);
}
