import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';

class MessageBubbleViewModel
    extends StreamViewModel<DocumentSnapshot<Object?>> {
  final String conversationId;
  final String messageUid;
  final FireUser fireUser;
  final String liveUserUid;
  MessageBubbleViewModel({
    required this.fireUser,
    required this.messageUid,
    required this.liveUserUid,
    required this.conversationId,
  });
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);



  Stream<DocumentSnapshot<Object?>> getMessage(
      String conversationId, String messageUid, String liveUserUid) {
    final message = conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .snapshots();

    return message;
  }

  @override
  void onError(error) {
    getLogger('MessageBubbleViewModel onError').e(error);
  }

  @override
  Stream<DocumentSnapshot<Object?>> get stream =>
      getMessage(conversationId, messageUid, liveUserUid);
}
