import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/dule/dule_view.dart';

import 'auth_service.dart';
import 'database_service.dart';
import 'nav_service.dart';

final ChatService chatService = ChatService();

class ChatService {
  static final log = getLogger('ChatService');
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;
  static final CollectionReference subsCollection =
      _firestore.collection(subsFirestoreKey);
  static final CollectionReference _conversationCollection =
      _firestore.collection(convoFirestorekey);

  final liveUserId = hiveApi.getUserDataWithHive(FireUserField.id);

  startConversation(
      BuildContext context, FireUser fireUser, Color randomColor) async {
   
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _conversationCollection.doc(chatRoomId).set(chatRoomMap);
  }

  startDuleConversation(BuildContext context, FireUser fireUser, ) async {
    String value =
                    chatService.getConversationId(fireUser.id, liveUserUid);
                navService.cupertinoPageRoute(
                    context, DuleView(fireUser: fireUser));
                await databaseService.updateUserDataWithKey(
                    DatabaseMessageField.roomUid, value);
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

 
  /// Archive the user
  Future<void> addToArchive(String fireuserId) async {
    await firestoreApi.updateRecentUser(
        value: true,
        fireUserUid: fireuserId,
        propertyName: RecentUserField.archive);
    await subsCollection
        .doc(AuthService.liveUser!.uid)
        .collection(archivesFirestorekey)
        .doc(fireuserId)
        .set({
      RecentUserField.userUid: fireuserId,
      RecentUserField.isFromContact: false,
      RecentUserField.timestamp: Timestamp.now(),
    });
  }

  /// Remove user from archive
  Future<void> removeFromArchive(String fireuserId) async {
    await subsCollection
        .doc(AuthService.liveUser!.uid)
        .collection(archivesFirestorekey)
        .doc(fireuserId)
        .delete();
    await firestoreApi.updateRecentUser(
        value: false,
        fireUserUid: fireuserId,
        propertyName: RecentUserField.archive);
  }

  _addToRecentListForSender(String receiverUid) async {
    final doc = await subsCollection
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .doc(receiverUid)
        .get();
    if (doc.exists) {
      subsCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(receiverUid)
          .update({RecentUserField.timestamp: Timestamp.now()})
          .then((value) => log.wtf(
              'timestamp for receiverUid : $receiverUid has been updated to timestamp : ${Timestamp.now()}'))
          .catchError((e) => log
              .e('timestamp : ${Timestamp.now()}receiverUid : $receiverUid'));
    } else {
      subsCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(receiverUid)
          .set({
            RecentUserField.pinned: false,
            RecentUserField.archive: false,
            RecentUserField.isFromContact: false,
            RecentUserField.userUid: receiverUid,
            RecentUserField.timestamp: Timestamp.now(),
          })
          .then((value) => log.wtf(
              'recieverUid : $receiverUid has been add to the user with id : $liveUserUid'))
          .catchError((e) => log.e(
              'There has been error in adding recieverUid : $receiverUid to user with id : $liveUserUid'));
    }
  }

  _addTORecentListForReceiver(String receiverUid) async {
    final doc = await subsCollection
        .doc(receiverUid)
        .collection(recentFirestoreKey)
        .doc(liveUserUid)
        .get();
    if (doc.exists) {
      subsCollection
          .doc(receiverUid)
          .collection(recentFirestoreKey)
          .doc(liveUserUid)
          .update({RecentUserField.timestamp: Timestamp.now()})
          .then((value) => log.wtf(
              'timestamp for user with id : $liveUserUid has been updated to timestamp : ${Timestamp.now()}'))
          .catchError((e) => log.e(
              'There has been error in updating timestamp for user with id : $liveUserUid'));
    } else {
      subsCollection
          .doc(receiverUid)
          .collection(recentFirestoreKey)
          .doc(liveUserUid)
          .set({
            RecentUserField.pinned: false,
            RecentUserField.archive: false,
            RecentUserField.isFromContact: false,
            RecentUserField.userUid: liveUserUid,
            RecentUserField.timestamp: Timestamp.now(),
          })
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
        .collection(subsFirestoreKey)
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  addFirestoreMessage({
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
      DocumentField.userBlockMe: userBlockMe,
      DocumentField.replyMessage: replyMessage,
    });
  }
}
