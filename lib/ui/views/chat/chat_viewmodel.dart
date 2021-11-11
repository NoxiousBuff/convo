import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatViewModel extends BaseViewModel {
  final log = getLogger('ChatViewModel');
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;
  ChatService chatService = ChatService();
  ChatViewModel({required this.conversationId, required this.fireUser});

  bool _iBlockThisUser = false;
  bool get iBlockThisUser => _iBlockThisUser;

  bool _userBlockMe = false;
  bool get userBlockMe => _userBlockMe;

  FireUser fireUser;

  String conversationId;

  final focusNode = FocusNode();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(convoFirestorekey);

  // For checking this conversation collection is empty or not.
  Future<bool> hasMessage(String conversationId) async {
    final snapshot = await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  void iBlockThisUserValue(bool block) {
    _iBlockThisUser = block;
    notifyListeners();
  }

  Future<bool> iBlockThisUserCkecker(
      String currentUserId, String fireUserId) async {
    final query = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(currentUserId)
        .get();

    final firestoreUser = FireUser.fromFirestore(query);

    _iBlockThisUser = firestoreUser.blockedUsers!.contains(fireUserId);
    notifyListeners();
    log.wtf('iBlockThisUser:$_iBlockThisUser');
    return firestoreUser.blockedUsers!.contains(fireUserId);
  }

  Future<bool> userBlockMeChecker(
      String fireuserId, String currentUserId) async {
    final query = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(fireuserId)
        .get();

    final firestoreUser = FireUser.fromFirestore(query);

    _userBlockMe = firestoreUser.blockedUsers!.contains(currentUserId);
    notifyListeners();
     log.wtf('userBlockMe:$_userBlockMe');
    return firestoreUser.blockedUsers!.contains(currentUserId);
  }

  Future<void> seeMsg() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUser.id)
        .where(DocumentField.isRead, isEqualTo: false)
        .where(DocumentField.userBlockMe, isEqualTo: false)
        .get()
        .then((query) {
      for (var document in query.docs) {
        batch.update(document.reference, {DocumentField.isRead: true});
      }
      return batch.commit();
    }).catchError((e) {
      getLogger('ChatViewModel').e('seeMsg:$e');
    });
  }

  // /// clear the chat from firestore or delete the all chat from firestore
  // Future<void> clearChat() async {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   setBusy(true);

  //   await conversationCollection
  //       .doc(conversationId)
  //       .collection(chatsFirestoreKey)
  //       .get()
  //       .then((querysnapshot) {
  //     for (var document in querysnapshot.docs) {
  //       batch.delete(document.reference);
  //     }
  //     return batch.commit();
  //   }).catchError((e) {
  //     getLogger('ChatViewModel|ClearChat').e('There is an error :$e');
  //   });

  //   getLogger('Clear Chat').wtf('Chat is deleted Succesfully');
  //   setBusy(false);
  // }
}
