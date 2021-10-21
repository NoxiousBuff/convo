import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:stacked/stacked.dart';

class LastMessageViewModel extends StreamViewModel<QuerySnapshot> {
  final String conversationId;
  LastMessageViewModel(this.conversationId);

  int unreadMessage = 0;

  Stream<QuerySnapshot> messages(String conversationId) {
    return FirebaseFirestore.instance
        .collection(convoFirestorekey)
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .snapshots();
  }

  Future<int> unreadMessageLength(String fireUserID) async {
    final unreadMsges = await FirebaseFirestore.instance
        .collection(convoFirestorekey)
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUserID)
        .where(DocumentField.isRead, isEqualTo: false)
        .where(DocumentField.userBlockMe, isEqualTo: false)
        .get();
    int length = unreadMsges.docs.length;
    length = unreadMessage;
    notifyListeners();
    return length;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => messages(conversationId);
}
