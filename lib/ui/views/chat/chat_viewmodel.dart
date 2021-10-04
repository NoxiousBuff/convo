// ignore_for_file: avoid_print
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatViewModel extends StreamViewModel<BoxEvent> {
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;
  ChatService chatService = ChatService();
  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  String? _uploadingMessageUid;
  String? get uploadingMessageUid => _uploadingMessageUid;

  final List<String> _messagesDate = [];
  List<String> get messagesDate => _messagesDate;

  final List<Timestamp> _messagesTimestamp = [];
  List<Timestamp> get messagesTimestamp => _messagesTimestamp;

  ScrollController? scrollController;
  final focusNode = FocusNode();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<BoxEvent> getChats(String conversationId) =>
      Hive.box(conversationId).watch();

  void getMessagesDate(String date) {
    _messagesDate.add(date);
  }

  void getTimeStamp(Timestamp _timestamp) {
    _messagesTimestamp.add(_timestamp);
  }

  Future<void> updateAProperty({
    required String messageUid,
    required Map<String, Object?> data,
  }) async {
    try {
      final query = await conversationCollection
          .doc(conversationId)
          .collection('Chat')
          .where("messageUid", isEqualTo: messageUid)
          .get();

      // print('Length:${query.docs.length}\n messageUid: $messageUid');

      // getLogger('UpdateAProperty')
      //     .wtf('Length:${query.docs.length}\n messageUid: $messageUid');

      for (var doc in query.docs) {
        doc.reference.update(data).whenComplete(() {});
      }
    } catch (e) {
      getLogger('UpdateAProperty Error').e(e);
    }
  }

  Future<void> seeMsg() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUser.id)
        .where(DocumentField.isRead, isEqualTo: false)
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
  Stream<BoxEvent> get stream => getChats(conversationId);
}
