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
      _firestore.collection(conversationFirestorekey);

  startConversation(
      BuildContext context, FireUser fireUser, Color randomColor) async {
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    await Hive.openBox(conversationId);
    await Hive.openBox("ChatRoomMedia[$conversationId]");
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

  Map<String, dynamic> addUnreadMsg({
    required bool isReply,
    required String senderUid,
    required String messageUid,
    required String messageType,
    required Timestamp timestamp,
    bool isRead = false,
    dynamic mediaPaths,
    dynamic mediaPathsType,
    String? messageText,
    String? imagePath,
    String? replyUid,
    String? replyType,
    dynamic replyMessage,
  }) {
    switch (messageType) {
      case textType:
        {
          return <String, dynamic>{
            "isRead": isRead,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": senderUid,
            "messageType": messageType,
            "messageText": messageText,
            "replyMessage": replyMessage,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }

      case imageType:
        {
          return <String, dynamic>{
            "isRead": isRead,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": senderUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      case videoType:
        {
          return <String, dynamic>{
            "isRead": isRead,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": senderUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      case multiMediaType:
        {
          return <String, dynamic>{
            "isRead": isRead,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": senderUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      default:
        {
          return {};
        }
    }
  }

  Map<String, dynamic> updateHiveMsg({
    required bool isRead,
    required bool isReply,
    required String replyUid,
    required String senderUid,
    required String replyType,
    required String messageUid,
    required bool removeMessage,
    required String messageType,
    required String messageText,
    required dynamic mediaPaths,
    required String replyMessage,
    required Timestamp timestamp,
    required dynamic mediaPathsType,
  }) {
    return <String, dynamic>{
      "isRead": isRead,
      "isReply": isReply,
      "replyUid": replyUid,
      "replyType": replyType,
      "mediaPaths": mediaPaths,
      "messageUid": messageUid,
      "senderUid": liveUserUid,
      "messageType": messageType,
      "messageText": messageText,
      "replyMessage": replyMessage,
      "removeMessage": removeMessage,
      "mediaPathsType": mediaPathsType,
      "timestamp": timestamp.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> addHiveMessage({
    required bool isReply,
    required String messageUid,
    required String messageType,
    required Timestamp timestamp,
    dynamic mediaPaths,
    dynamic mediaPathsType,
    String? messageText,
    String? imagePath,
    String? replyUid,
    String? replyType,
    dynamic replyMessage,
  }) {
    switch (messageType) {
      case textType:
        {
          return <String, dynamic>{
            "isRead": false,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": liveUserUid,
            "messageType": messageType,
            "messageText": messageText,
            "replyMessage": replyMessage,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }

      case imageType:
        {
          return <String, dynamic>{
            "isRead": false,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": liveUserUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      case videoType:
        {
          return <String, dynamic>{
            "isRead": false,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": liveUserUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      case multiMediaType:
        {
          return <String, dynamic>{
            "isRead": false,
            "isReply": isReply,
            "replyUid": replyUid,
            "removeMessage": false,
            "replyType": replyType,
            "messageUid": messageUid,
            "senderUid": liveUserUid,
            "mediaPaths": mediaPaths,
            "messageType": messageType,
            "replyMessage": replyMessage,
            "mediaPathsType": mediaPathsType,
            "timestamp": timestamp.millisecondsSinceEpoch,
          };
        }
      default:
        {
          return {};
        }
    }
  }

  addFirestoreMessage({
    bool isReply = false,
    GeoPoint? location,
    bool isRead = false,
    String? messageText,
    dynamic mediaUrls,
    dynamic mediaUrlsType,
    required String type,
    required String messageUid,
    required String receiverUid,
    required Timestamp timestamp,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    final Map messageMap = {};
    final Map replyMessageMap = {};
    if (location != null) messageMap[MessageField.location] = location;
    if (messageText != null) messageMap[MessageField.messageText] = messageText;
    if (mediaUrls != null) messageMap[MessageField.mediaUrls] = mediaUrls;
    if (mediaUrlsType != null) messageMap[MessageField.mediaUrlsType] = mediaUrlsType;
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
      DocumentField.replyMessage: replyMessageMap,
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
