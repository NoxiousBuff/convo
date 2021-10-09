import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animations/animations.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/chat/chat_view.dart';
import 'package:hint/routes/shared_axis_route.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final ChatService chatService = ChatService();

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference _conversationCollection =
      _firestore.collection(convoFirestorekey);

  startConversation(
      BuildContext context, FireUser fireUser, Color randomColor) async {
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    await Hive.openBox(conversationId);
    await Hive.openBox('UrlData[$conversationId]');
    await Hive.openBox('ImagesMemory[$conversationId]');
    await Hive.openBox("ChatRoomMedia[$conversationId]");
    await Hive.openBox('ThumbnailsPath[$conversationId]');
    await Hive.openBox('VideoThumbnails[$conversationId]');
    Map<String, dynamic> chatRoomMap = {
      'nearMe': false,
      'liveUserUid': liveUserUid,
      'receiverUid': fireUser.id,
      'chatRoomId': conversationId,
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
      // ignore: unnecessary_string_escapes
      return '$b\_$a';
    } else {
      // ignore: unnecessary_string_escapes
      return '$a\_$b';
    }
  }

  addFirestoreMessage({
    bool isReply = false,
    GeoPoint? location,
    bool isRead = false,
    String? messageText,
    dynamic mediaURL,
    required String type,
    bool uploaded = false,
    final Map? replyMessage,
    required String messageUid,
    required String receiverUid,
    required Timestamp timestamp,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    final Map messageMap = {};
    messageMap[MessageField.uploaded] = false;
    if (location != null) messageMap[MessageField.location] = location;
    if (messageText != null) messageMap[MessageField.messageText] = messageText;
    if (mediaURL != null) messageMap[MessageField.mediaURL] = mediaURL;

    _conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .set({
      DocumentField.type: type,
      DocumentField.isRead: isRead,
      DocumentField.isReply: isReply,
      DocumentField.message: messageMap,
      DocumentField.timestamp: timestamp,
      DocumentField.messageUid: messageUid,
      DocumentField.senderUid: liveUserUid,
      DocumentField.replyMessage: replyMessage,
    });
  }

  // addMessage({
  //   required String receiverUid,
  //   required String type,
  //   required bool isReply,
  //   String? messageText,
  //   String? mediaUrl,
  //   String? link,
  //   GeoPoint? location,
  //   String? replyMediaUrl,
  //   String? replyMsg,
  //   String? replyMsgId,
  //   String? replyType,
  //   String? replyUid,
  // }) {
  //   String conversationId = getConversationId(receiverUid, liveUserUid);
  //   String randomKey = const Uuid().v1();
  //   _conversationCollection
  //       .doc(conversationId)
  //       .collection(chatsFirestoreKey)
  //       .add({
  //     'isReply': isReply,
  //     'link': link,
  //     'location': location,
  //     'mediaUrl': mediaUrl,
  //     'messageText': messageText,
  //     'messageUid': randomKey,
  //     'receiverUid': receiverUid,
  //     'replyMediaUrl': replyMediaUrl,
  //     'replyMsgId': replyMsgId,
  //     'replyMsg': replyMsg,
  //     'replyType': replyType,
  //     'replyUid': replyUid,
  //     'senderUid': liveUserUid,
  //     'status': 'Delivered',
  //     'timestamp': Timestamp.now(),
  //     'type': type,
  //   });
  // }
}
