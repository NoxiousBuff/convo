// ignore_for_file: avoid_print
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatViewModel extends StreamViewModel<QuerySnapshot> {
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;
  ChatService chatService = ChatService();
  ChatViewModel({required this.conversationId, required this.fireUser});

  Stream<DocumentSnapshot<Map<String, dynamic>>> statusStream(
      String fireUserID) {
    return FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(fireUserID)
        .snapshots();
  }

  String _backgroundImagePath = '';
  String get backgroungImagePath => _backgroundImagePath;

  bool _iBlockThisUser = false;
  bool get iBlockThisUser => _iBlockThisUser;

  bool _userBlockMe = false;
  bool get userBlockMe => _userBlockMe;

  FireUser fireUser;

  String conversationId;

  final List<String> _messagesDate = [];
  List<String> get messagesDate => _messagesDate;

  final List<Timestamp> _messagesTimestamp = [];
  List<Timestamp> get messagesTimestamp => _messagesTimestamp;

  ScrollController? scrollController;
  final focusNode = FocusNode();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(convoFirestorekey);

  void iBlockThisUserValue(bool block) {
    _iBlockThisUser = block;
    notifyListeners();
  }

  void getBackgroundImagePath(String path) {
    _backgroundImagePath = path;
    notifyListeners();
    getLogger('ChatView').w('path:$path');
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
    return firestoreUser.blockedUsers!.contains(currentUserId);
  }

  Stream<QuerySnapshot> getChats(String conversationId) {
    return conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  void getMessagesDate(String date) {
    _messagesDate.add(date);
  }

  void getTimeStamp(Timestamp _timestamp) {
    _messagesTimestamp.add(_timestamp);
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

  /// clear the chat from firestore or delete the all chat from firestore
  Future<void> clearChat() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    setBusy(true);

    await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .get()
        .then((querysnapshot) {
      for (var document in querysnapshot.docs) {
        batch.delete(document.reference);
      }
      return batch.commit();
    }).catchError((e) {
      getLogger('ChatViewModel|ClearChat').e('There is an error :$e');
    });

    getLogger('Clear Chat').wtf('Chat is deleted Succesfully');
    setBusy(false);
  }

  @override
  Stream<QuerySnapshot> get stream => getChats(conversationId);
}
