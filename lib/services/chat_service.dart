// ignore_for_file: unnecessary_string_escapes

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/model_string.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/routes/shared_axis_route.dart';
import 'package:hint/ui/views/chat/chat_view.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final log = getLogger('ChatService');

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference _conversationCollection =
      _firestore.collection(conversationFirestorekey);
  static final CollectionReference _subsCollection =
      _firestore.collection(subsFirestoreKey);
  final FirestoreApi _firestoreApi = FirestoreApi();

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
    // ignore: duplicate_ignore
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
    String? mediaUrl,
    List<String?>? mediaType,
    List<String?>? mediaList,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    String messageUid = const Uuid().v1();
    final Map messageMap = {};
    final Map replyMessageMap = {};
    if (location != null) messageMap[MessageField.location] = location;
    if (messageText != null) messageMap[MessageField.messageText] = messageText;
    if (mediaUrl != null) messageMap[MessageField.mediaUrl] = mediaUrl;
    if (mediaList != null) messageMap[MessageField.mediaList] = mediaList;
    if (mediaType != null) messageMap[MessageField.mediaType] = mediaType;
    _conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .add({
      DocumentField.isRead: isRead,
      DocumentField.isReply: isReply,
      DocumentField.message: messageMap,
      DocumentField.messageUid: messageUid,
      DocumentField.replyMessage: replyMessageMap,
      DocumentField.senderUid: liveUserUid,
      DocumentField.timestamp: Timestamp.now(),
      DocumentField.type: type,
    });
  }

  addToRecentListForSender(String receiverUid) async {
    final doc = await _subsCollection
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .doc(receiverUid)
        .get();
    if (doc.exists) {
      _subsCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(receiverUid)
          .update({'timestamp': Timestamp.now()})
          .then((value) => log.wtf(
              'timestamp for receiverUid : $receiverUid has been updated to timestamp : ${Timestamp.now()}'))
          .catchError((e) => log.e(
              'timestamp : ${Timestamp.now()}receiverUid : $receiverUid'));
    } else {
      _subsCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(receiverUid)
          .set({'userUid': receiverUid, 'timestamp': Timestamp.now()})
          .then((value) => log.wtf(
              'recieverUid : $receiverUid has been add to the user with id : $liveUserUid'))
          .catchError((e) => log.e(
              'There has been error in adding recieverUid : $receiverUid to user with id : $liveUserUid'));
    }
  }

  addTORecentListForReceiver(String receiverUid) async {
    final doc = await _subsCollection
        .doc(receiverUid)
        .collection(recentFirestoreKey)
        .doc(liveUserUid).get();
    if(doc.exists) {
      _subsCollection
        .doc(receiverUid)
        .collection(recentFirestoreKey)
        .doc(liveUserUid)
        .update({'timestamp': Timestamp.now()})
        .then((value) => log.wtf(
            'timestamp for user with id : $liveUserUid has been updated to timestamp : ${Timestamp.now()}'))
        .catchError((e) => log.e(
            'There has been error in updating timestamp for user with id : $liveUserUid'));
    } else {
      _subsCollection
        .doc(receiverUid)
        .collection(recentFirestoreKey)
        .doc(liveUserUid)
        .set({'userUid': liveUserUid, 'timestamp': Timestamp.now()})
        .then((value) => log.wtf(
            'user with id : $liveUserUid has been add to the recieverUid : $receiverUid'))
        .catchError((e) => log.e(
            'There has been error in adding user with id : $liveUserUid to recieverUid : $receiverUid'));
    }
  }

  Stream<QuerySnapshot> getRecentChatList() {
    return _firestore.collection(subsFirestoreKey).doc(liveUserUid).collection(recentFirestoreKey).orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> addToRecentList(String receiverUid) async {
    addToRecentListForSender(receiverUid);
    addTORecentListForReceiver(receiverUid);
  }

  Future<FireUser?> getUserFromUserUId(String userUid) async {
    return await _firestoreApi.getUserFromFirebase(userUid);
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
    _conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .add({
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
