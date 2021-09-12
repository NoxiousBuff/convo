import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/routes/shared_axis_route.dart';
import 'package:hint/ui/views/chat/chat_view.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference _conversationCollection =
      _firestore.collection('Conversation');

  startConversation(BuildContext context, String receiverUid,
      String? receiverUserName, String? receiverPhotoUrl, Color? randomColor) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    Map<String, dynamic> chatRoomMap = {
      'chatRoomId': conversationId,
      'nearMe': false,
      'liveUserUid': liveUserUid,
      'receiverUid': receiverUid,
    };

    createChatRoom(conversationId, chatRoomMap);
    final route = SharedAxisPageRoute(
      page: ChatView(
        randomColor: randomColor,
        conversationId: conversationId,
        receiverUserName: receiverUserName,
        receiverUid: receiverUid,
        receiverPhotoUrl: receiverPhotoUrl,
      ),
      transitionType: SharedAxisTransitionType.scaled,
    );
    Navigator.of(context, rootNavigator: true).push(route);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _conversationCollection.doc(chatRoomId).set(chatRoomMap);
  }

  getConversationId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b/_$a';
    } else {
      return '$a/_$b';
    }
  }

  // addTextMessage(String messageText, String receiverUid) {
  //   String conversationId = getConversationId(receiverUid, liveUserUid);
  //   String randomKey = Uuid().v1();
  //   _conversationCollection.doc(conversationId).collection('Chat').add({
  //     'messageUid':
  //         randomKey ?? DateTime.now().microsecondsSinceEpoch.toString(),
  //     'mediaUrl': null,
  //     'isReceiverFocused': false,
  //     'location': null,
  //     'messageText': messageText,
  //     'receiverUid': receiverUid,
  //     'senderUid': liveUserUid,
  //     'status': 'Delivered',
  //     'timer': null,
  //     'timestamp': Timestamp.now(),
  //     'type': 'text',
  //     'replyMsg': null,
  //     'replyUid': null,
  //     'isReply': null,
  //     'replyMsgId': null,
  //     'replyType': null,
  //     'link': null,
  //   });
  // }

  addMessage({
    required String receiverUid,
    required String type,
    required bool isReply,
    String? messageText,
    String? mediaUrl,
    String? link,
    GeoPoint? location,
    String? replyMediaUrl,
    String? replyMsg,
    String? replyMsgId,
    String? replyType,
    String? replyUid,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    String randomKey = const Uuid().v1();
    _conversationCollection.doc(conversationId).collection('Chat').add({
      'isReply': isReply,
      'link': link,
      'location': location,
      'mediaUrl': mediaUrl,
      'messageText': messageText,
      'messageUid': randomKey,
      'receiverUid': receiverUid,
      'replyMediaUrl': replyMediaUrl,
      'replyMsgId': replyMsgId,
      'replyMsg': replyMsg,
      'replyType': replyType,
      'replyUid': replyUid,
      'senderUid': liveUserUid,
      'status': 'Delivered',
      'timestamp': Timestamp.now(),
      'type': type,
    });
  }
}
