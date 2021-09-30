import 'dart:async';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessagesViewModel extends StreamViewModel<QuerySnapshot> {
  ChatMessagesViewModel({
    required this.conversationId,
    required this.fireUser,
  });

  FireUser fireUser;


  String conversationId;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<QuerySnapshot> getChats(String conversationId) {
    final unreadMsges = conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUser.id)
        .where(DocumentField.isRead, isEqualTo: false)
        .snapshots();
    return unreadMsges;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getChats(conversationId);
}
