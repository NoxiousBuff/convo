import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/new_message_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';

class MessageBubbleViewModel extends FutureViewModel<QuerySnapshot<Object?>> {
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

  bool isMessageExistsInFirebase = false;
  late NewMessage firestoreMessage;
  bool isMessageRead = false;

  Future<QuerySnapshot<Object?>> getMessage(
      String conversationId, String messageUid, String liveUserUid) async {
    final message = await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.messageUid, isEqualTo: messageUid)
        .where(DocumentField.isRead, isEqualTo: false)
        .get();

    return message;
  }

  @override
  Future<QuerySnapshot> futureToRun() =>
      getMessage(conversationId, messageUid, liveUserUid);

  @override
  void onError(error) {
    getLogger('MessageBubbleViewModel onError').e(error);
  }
}
