import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hint/services/chat_service.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends StreamViewModel<QuerySnapshot> {
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;
  final log = getLogger('ChatViewModel');
  final ChatService _chatService = ChatService();

  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  ScrollController? scrollController;
  final focusNode = FocusNode();

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<QuerySnapshot> getChats(String conversationId) {
    return conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .orderBy(
          'timestamp',
          descending: true
        )
        .snapshots();
  }

  onDispose() {
    log.wtf('On Dispose Method has been started');
    _chatService.addToRecentList(fireUser.id);
    log.wtf('On Dispose has been finished');
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getChats(conversationId);
}