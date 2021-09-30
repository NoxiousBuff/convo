import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:stacked/stacked.dart';

class MessageBubbleViewModel extends StreamViewModel<QuerySnapshot<Object?>> {
  final String conversationId;
  final String messageUid;
  final String liveUserUid;
  MessageBubbleViewModel(
      {required this.conversationId,
      required this.messageUid,
      required this.liveUserUid});
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<QuerySnapshot> getMessage(
      String conversationId, String messageUid, String liveUserUid) {
    final message = conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.messageUid, isEqualTo: messageUid)
        .where(DocumentField.isRead, isEqualTo: false)
        .snapshots();
    return message;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream =>
      getMessage(conversationId, messageUid, liveUserUid);
}
