import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/routes/shared_axis_route.dart';
import 'package:hint/ui/views/chat/chat_view.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference _conversationCollection =
      _firestore.collection(conversationFirestorekey);

  startConversation(
      BuildContext context, FireUser fireUser, Color randomColor) {
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    Map<String, dynamic> chatRoomMap = {
      'chatRoomId': conversationId,
      'nearMe': false,
      'liveUserUid': liveUserUid,
      'receiverUid': fireUser.id,
    };

    createChatRoom(conversationId, chatRoomMap);
    final route = SharedAxisPageRoute(
      page: ChatView(
        randomColor: randomColor,
        conversationId: conversationId,
        fireUser: fireUser,
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
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  addNewMessage({
    required String receiverUid,
    required String type,
    bool isReply = false,
    GeoPoint? location,
    bool isRead = false,
    String? messageText,
    List<String?>? mediaType,
    List<String?>? mediaList,
    bool removeForMe = false,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    String randomKey = const Uuid().v1();
    final Map<String, dynamic> messageMap = {};
    final Map<String, dynamic> replyMessageMap = {};
    if (location != null) messageMap['location'] = location;
    if (messageText != null) messageMap['messageText'] = messageText;
    if (mediaList != null) messageMap['mediaList'] = mediaList;
    if (mediaType != null) messageMap['mediaType'] = mediaType;
    _conversationCollection.doc(conversationId).collection('Chat').add({
      'isRead': isRead,
      'isReply': isReply,
      'message': messageMap,
      'messageUid': randomKey,
      'replyMessage': replyMessageMap,
      'senderUid': liveUserUid,
      'timestamp': Timestamp.now(),
      'type': type,
    });
  }

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
