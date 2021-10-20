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

  _addToRecentListForSender(FireUser fireUser) async {
    final recentUser = await _userCollection
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .doc(fireUser.id)
        .get();
    if (!recentUser.exists) {
      _userCollection
          .doc(liveUserUid)
          .collection(recentFirestoreKey)
          .doc(fireUser.id)
          .set({
        UserField.bio: fireUser.bio,
        UserField.email: fireUser.email,
        UserField.blockedUsers: fireUser.blockedUsers,
        UserField.id: fireUser.id,
        UserField.interests: fireUser.interests,
        UserField.lastSeen: fireUser.lastSeen,
        UserField.phone: fireUser.phone,
        UserField.photoUrl: fireUser.photoUrl,
        UserField.status: fireUser.status,
        UserField.username: fireUser.username,
        UserField.userCreated: fireUser.userCreated,
      });
    } else {
      log.wtf('SenderRecentUser already exists : ${fireUser.email}');
    }
  }

  _addTORecentListForReceiver(FireUser fireUser) async {
    final recentUser = await _userCollection
        .doc(fireUser.id)
        .collection(recentFirestoreKey)
        .doc(liveUserUid)
        .get();
    if (!recentUser.exists) {
      _userCollection
          .doc(fireUser.id)
          .collection(recentFirestoreKey)
          .doc(liveUserUid)
          .set({
        UserField.bio: fireUser.bio,
        UserField.email: fireUser.email,
        UserField.blockedUsers: fireUser.blockedUsers,
        UserField.id: fireUser.id,
        UserField.interests: fireUser.interests,
        UserField.lastSeen: fireUser.lastSeen,
        UserField.phone: fireUser.phone,
        UserField.photoUrl: fireUser.photoUrl,
        UserField.status: fireUser.status,
        UserField.username: fireUser.username,
        UserField.userCreated: fireUser.userCreated,
      });
    } else {
      log.wtf('ReceiverRecentUser:${fireUser.email}');
    }
  }

  void addTorecentsChat(FireUser fireUser) {
    _addTORecentListForReceiver(fireUser);
    _addToRecentListForSender(fireUser);
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
