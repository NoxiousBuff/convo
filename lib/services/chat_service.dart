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
import 'package:hint/ui/views/dule/dule_view.dart';

import 'database_service.dart';
import 'nav_service.dart';

final ChatService chatService = ChatService();

class ChatService {
  final firestoreApi = locator<FirestoreApi>();

  static final log = getLogger('ChatService');

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final String liveUserUid = _auth.currentUser!.uid;

  static final CollectionReference subsCollection =
      _firestore.collection(subsFirestoreKey);

  Future<void> updateRoomId(FireUser fireUser) async {
    String value = chatService.getConversationId(fireUser.id, liveUserUid);
    await databaseService.updateUserDataWithKey(
        DatabaseMessageField.roomUid, value);
  }

  startDuleConversation(
    BuildContext context,
    FireUser fireUser,
  ) {
    navService.cupertinoPageRoute(context, DuleView(fireUser: fireUser));
    updateRoomId(fireUser);
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
}
