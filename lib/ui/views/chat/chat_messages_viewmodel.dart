import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessagesViewModel extends StreamViewModel<QuerySnapshot> {
  ChatMessagesViewModel({
    required this.conversationId,
    required this.fireUser,
  });

  final log = getLogger('ChatViewModel');

  FireUser fireUser;

  String conversationId;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(convoFirestorekey);

  final List<String> _messagesDate = [];
  List<String> get messagesDate => _messagesDate;

  final List<Timestamp> _messagesTimestamp = [];
  List<Timestamp> get messagesTimestamp => _messagesTimestamp;

  void getMessagesDate(String date) {
    _messagesDate.add(date);
  }

  void getTimeStamp(Timestamp _timestamp) {
    _messagesTimestamp.add(_timestamp);
  }

  Stream<QuerySnapshot> getChats(String conversationId) {
    return conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getChats(conversationId);
}
