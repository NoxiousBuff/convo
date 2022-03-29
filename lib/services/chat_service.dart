import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat/chat_view.dart';
import 'package:uuid/uuid.dart';

import 'database_service.dart';
import 'nav_service.dart';

final ChatService chatService = ChatService();

class ChatService {
  final firestoreApi = locator<FirestoreApi>();

  static final log = getLogger('ChatService');

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final String liveUserUid = _auth.currentUser!.uid;

  final databaseService = DatabaseService();

  static final CollectionReference subsCollection =
      _firestore.collection(subsFirestoreKey);

  static final CollectionReference _conversationCollection =
      _firestore.collection(conversationFirestorekey);

  Future<void> updateRoomId(FireUser fireUser) async {
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    Map<String, dynamic> chatRoomMap = {
      'chatRoomId': conversationId,
      'nearMe': false,
      'liveUserUid': liveUserUid,
      'receiverUid': fireUser.id,
    };

    createChatRoom(conversationId, chatRoomMap);
    await databaseService.updateUserDataWithKey(
        DatabaseMessageField.roomUid, conversationId);
  }

  startDuleConversation(
    BuildContext context,
    FireUser fireUser,
  ) {
    // navService.cupertinoPageRoute(context, DuleView(fireUser: fireUser));
    String conversationId = getConversationId(fireUser.id, liveUserUid);
    navService.cupertinoPageRoute(
        context, ChatView(fireUser: fireUser, conversationId: conversationId));
    updateRoomId(fireUser);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _conversationCollection.doc(chatRoomId).set(chatRoomMap);
  }

  String getConversationId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return '$b\_$a';
    } else {
      // ignore: unnecessary_string_escapes
      return '$a\_$b';
    }
  }

  /// Delete a chat message from a conversation room
  Future deleteChatMsg(String fireUserUid, String messageUid) async {
    String currentUserUid = FirestoreApi().getCurrentUser!.uid;
    String conversationID = getConversationId(fireUserUid, currentUserUid);
    return _conversationCollection
        .doc(conversationID)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .delete()
        .then((value) => log.wtf("Message Deleted"))
        .catchError((error) => log.e("Failed to delete message: $error"));
  }

  /// update message in firestore database
  Future updateMessage(
      {required String fireUserUid,
      required String messageUid,
      required String fieldName,
      required dynamic fielValue}) async {
    String currentUserUid = FirestoreApi().getCurrentUser!.uid;
    String conversationID = getConversationId(fireUserUid, currentUserUid);

    return _conversationCollection
        .doc(conversationID)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .update({fieldName: fielValue})
        .then((value) => log.wtf("Message Updated"))
        .catchError((error) => log.e("Failed to update message: $error"));
  }

  /// Add a new message in firestore database
  Future<String> addNewMessage({
    required String receiverUid,
    required String type,
    bool isReply = false,
    bool isRead = false,
    int? fileSize,
    String? blurHash,
    String? localPath,
    String? messageText,
    String? documentTitle,
    String? mediaUrl,
    String? swipeHash,
    String? swipeMsgUid,
    String? swipeMsgType,
    String? swipeMsgText,
    String? swipeMediaURL,
    String? swipeDocTitle,
    String? senderThumbnail,
    String? swipeLocalPath,
    String? swipeThumbnail,
  }) async {
    String conversationId = getConversationId(receiverUid, liveUserUid);
    String messageUid = const Uuid().v1();
    final Map reactions = {};
    final Map messageMap = {};
    final Map replyMsgMap = {};
    const fMessageText = MessageField.messageText;
    const fMediaURL = MessageField.mediaUrl;

    /// MessageMap Fields
    if (messageText != null) messageMap[fMessageText] = messageText;
    if (mediaUrl != null) messageMap[fMediaURL] = mediaUrl;
    if (blurHash != null) messageMap[MessageField.blurHash] = blurHash;
    if (fileSize != null) messageMap[MessageField.size] = fileSize;
    if (localPath != null) messageMap[MessageField.senderLocalPath] = localPath;
    if (senderThumbnail != null) {
      messageMap[MessageField.senderThumbnail] = senderThumbnail;
    }
    if (documentTitle != null) {
      messageMap[MessageField.documentTitle] = documentTitle;
    }

    /// ReplyMessage Fields
    if (swipeHash != null) replyMsgMap[RMField.hash] = swipeHash;
    if (swipeMsgType != null) replyMsgMap[RMField.type] = swipeMsgType;
    if (swipeMsgUid != null) replyMsgMap[RMField.messageUid] = swipeMsgUid;
    if (swipeMediaURL != null) replyMsgMap[RMField.mediaURL] = swipeMediaURL;
    if (swipeMsgText != null) replyMsgMap[RMField.messageText] = swipeMsgText;
    if (swipeLocalPath != null) replyMsgMap[RMField.localPath] = swipeLocalPath;
    if (swipeDocTitle != null) replyMsgMap[RMField.docTitle] = swipeDocTitle;
    if (swipeThumbnail != null) {
      replyMsgMap[RMField.thumbnailPath] = swipeThumbnail;
    }

    await _conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .set({
      DocumentField.isRead: isRead,
      DocumentField.isReply: isReply,
      DocumentField.message: messageMap,
      DocumentField.messageUid: messageUid,
      DocumentField.replyMessage: replyMsgMap,
      DocumentField.senderUid: liveUserUid,
      DocumentField.timestamp: Timestamp.now(),
      DocumentField.type: type,
      DocumentField.reactions: reactions,
    });
    return messageUid;
  }

  /// Archive the user
  Future<void> addToArchive(String fireuserId) async {
    await firestoreApi.updateRecentUser(
        value: true,
        fireUserUid: fireuserId,
        propertyName: RecentUserField.archive);
  }

  /// Remove user from archive
  Future<void> removeFromArchive(String fireuserId) async {
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

  /// Add the message in firestore and return the messageUid of the added message
  Future<String> addMsgAndGetUid({
    String? hash,
    int? fileSize,
    String? localPath,
    String? thumbnailPath,
    String? documentTitle,
    required String mediaType,
    required String downloadURL,
    required String receiverUid,
  }) async {
    switch (mediaType) {
      case MediaType.image:
        {
          // * Add message when type is image
          // * we need blurhash for display raw data of video thumbnail
          // * if image is not present offline of in firestore storage
          // * OR is hive path is empty
          final messageUid = await chatService
              .addNewMessage(
                  blurHash: hash,
                  type: mediaType,
                  fileSize: fileSize,
                  localPath: localPath,
                  mediaUrl: downloadURL,
                  receiverUid: receiverUid)
              .whenComplete(() => log.w('Image Message added'));
          return messageUid;
        }

      case MediaType.video:
        {
          // * Add message when type is video
          // * we need blurhash for display raw data of image
          // * if image is not present offline of in firestore storage
          // * OR is hive path is empty
          final messageUid = await chatService
              .addNewMessage(
                  blurHash: hash,
                  type: mediaType,
                  fileSize: fileSize,
                  localPath: localPath,
                  mediaUrl: downloadURL,
                  receiverUid: receiverUid,
                  senderThumbnail: thumbnailPath)
              .whenComplete(() => log.w('Video Message added'));
          return messageUid;
        }
      case MediaType.document:
        {
          // * Add message when type is document
          final messageUid = await chatService
              .addNewMessage(
                  type: mediaType,
                  mediaUrl: downloadURL,
                  receiverUid: receiverUid,
                  documentTitle: documentTitle)
              .whenComplete(() => log.w('Document Message added'));
          return messageUid;
        }
      default:
        {
          // * This is the default case for adding message in firestore database
          final messageUid = await chatService
              .addNewMessage(
                  type: mediaType,
                  mediaUrl: downloadURL,
                  receiverUid: receiverUid)
              .whenComplete(() => log.w('Document Message added'));
          return messageUid;
        }
    }
  }
}
