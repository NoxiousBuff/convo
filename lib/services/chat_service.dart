
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
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
  static final log = getLogger('ChatService');
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference _userCollection =
      _firestore.collection(usersFirestoreKey);
  static final CollectionReference _conversationCollection =
      _firestore.collection(convoFirestorekey);

  startConversation(
      BuildContext context, FireUser fireUser, Color randomColor) async {
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    await Hive.openBox(urlData(conversationId));
    await Hive.openBox(imagesMemory(conversationId));
    await Hive.openBox(chatRoomMedia(conversationId));
    await Hive.openBox(thumbnailsPath(conversationId));
    await Hive.openBox(videoThumbnails(conversationId));
    Map<String, dynamic> chatRoomMap = {
      'nearMe': false,
      'backgroundImage': null,
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

  _addToRecentListForSender(String receiverUid) async {
    final doc = await _userCollection
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .doc(receiverUid)
        .get();
    if (doc.exists) {
      _userCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(receiverUid)
          .update({'timestamp': Timestamp.now()})
          .then((value) => log.wtf(
              'timestamp for receiverUid : $receiverUid has been updated to timestamp : ${Timestamp.now()}'))
          .catchError((e) => log
              .e('timestamp : ${Timestamp.now()}receiverUid : $receiverUid'));
    } else {
      _userCollection
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

  _addTORecentListForReceiver(String receiverUid) async {
    final doc = await _userCollection
        .doc(receiverUid)
        .collection(recentFirestoreKey)
        .doc(liveUserUid)
        .get();
    if (doc.exists) {
      _userCollection
          .doc(receiverUid)
          .collection(recentFirestoreKey)
          .doc(liveUserUid)
          .update({'timestamp': Timestamp.now()})
          .then((value) => log.wtf(
              'timestamp for user with id : $liveUserUid has been updated to timestamp : ${Timestamp.now()}'))
          .catchError((e) => log.e(
              'There has been error in updating timestamp for user with id : $liveUserUid'));
    } else {
      _userCollection
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

  Future<void> addToRecentList(String receiverUid) async {
    _addToRecentListForSender(receiverUid);
    _addTORecentListForReceiver(receiverUid);
  }

  Stream<QuerySnapshot> getRecentChatList() {
    return _firestore
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  Future<void> addFirestoreMessage({
    dynamic mediaURL,
    GeoPoint? location,
    bool isRead = false,
    String? messageText,
    bool isReply = false,
    bool uploaded = false,
    // ---------------------//
    required String type,
    final Map? replyMessage,
    required bool userBlockMe,
    required String messageUid,
    required String receiverUid,
    required Timestamp timestamp,
  }) {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    final Map messageMap = {};
    if (location != null) messageMap[MessageField.location] = location;
    if (messageText != null) messageMap[MessageField.messageText] = messageText;
    if (mediaURL != null) messageMap[MessageField.mediaURL] = mediaURL;

    switch (type) {
      case MediaType.image:
        {
          messageMap[MessageField.uploaded] = false;
        }
        break;
      case MediaType.video:
        {
          messageMap[MessageField.uploaded] = false;
        }
        break;
      case MediaType.canvasImage:
        {
          messageMap[MessageField.uploaded] = false;
        }
        break;
      default:
        {
          null;
        }
    }

  return  _conversationCollection
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
      DocumentField.userBlockMe: userBlockMe,
      DocumentField.replyMessage: replyMessage,
    });
  }
}
