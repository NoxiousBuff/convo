import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageViewModel extends StreamViewModel<QuerySnapshot> {
  final String conversationId;
  LastMessageViewModel(this.conversationId);

  final log = getLogger('LastMessageViewModel');


  Stream<QuerySnapshot> messages(String conversationId) {
    return FirebaseFirestore.instance
        .collection(convoFirestorekey)
        .doc(conversationId)
        .collection(chatsFirestoreKey).orderBy(MessageField.timestamp)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => messages(conversationId);
}
