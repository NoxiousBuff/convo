// ignore_for_file: avoid_print

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatViewModel extends StreamViewModel<BoxEvent> {
  final TextEditingController _messageTech = TextEditingController();
  TextEditingController get messageTech => _messageTech;
  ChatService chatService = ChatService();
  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  String? _uploadingMessageUid;
  String? get uploadingMessageUid => _uploadingMessageUid;

  final List<String> _messagesDate = [];
  List<String> get messagesDate => _messagesDate;

  final List<Timestamp> _messagesTimestamp = [];
  List<Timestamp> get messagesTimestamp => _messagesTimestamp;

  ScrollController? scrollController;
  final focusNode = FocusNode();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  Stream<BoxEvent> getChats(String conversationId) =>
      Hive.box(conversationId).watch();

  void getMessagesDate(String date) {
    _messagesDate.add(date);
  }

  void getTimeStamp(Timestamp _timestamp) {
    _messagesTimestamp.add(_timestamp);
  }

  Future<void> seeMsg() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUser.id)
        .where(DocumentField.isRead, isEqualTo: false)
        .get()
        .then((query) {
      for (var document in query.docs) {
        batch.update(document.reference, {DocumentField.isRead: true});
      }
      return batch.commit();
    }).catchError((e) {
      getLogger('ChatViewModel').e('seeMsg:$e');
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMsges() {
    final unreadMsges = conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .where(DocumentField.senderUid, isEqualTo: fireUser.id)
        .where(DocumentField.isRead, isEqualTo: false)
        .snapshots();
    return unreadMsges;
  }

  /// clear the chat from firestore or delete the all chat from firestore
  Future<void> clearChat() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    setBusy(true);

    await conversationCollection
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .get()
        .then((querysnapshot) {
      for (var document in querysnapshot.docs) {
        batch.delete(document.reference);
      }
      return batch.commit();
    }).catchError((e) {
      getLogger('ChatViewModel|ClearChat').e('There is an error :$e');
    });

    getLogger('Clear Chat').wtf('Chat is deleted Succesfully');
    setBusy(false);
  }

  @override
  Stream<BoxEvent> get stream => getChats(conversationId);

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  final bool _isuploading = false;
  bool get isuploading => _isuploading;

  /// message added in hiveMessages chat list
  Future<void> saveFileInHive({
    bool isReply = false,
    required String filePath,
    required String messageUid,
    required String messageType,
    required String hiveBoxName,
    required Timestamp messageTime,
    required String messageReading,
  }) async {
    final fileType = lookupMimeType(filePath)!.split("/").first;
    final message = chatService.addHiveMessage(
      isReply: isReply,
      mediaPaths: filePath,
      messageUid: messageUid,
      timestamp: messageTime,
      mediaPathsType: fileType,
      messageType: messageType,
      messageReading: messageReading,
    );
    await Hive.box(hiveBoxName).add(message);
    getLogger('ChetViewModel|saveFileInHive').wtf("Added Message$message");
    final hiveBox = Hive.box('VideoThumbnails[$conversationId]');
    if (fileType == videoType) {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: filePath,
        imageFormat: ImageFormat.JPEG,
      );
      hiveBox.put(messageUid, thumbnail);
      final path = hiveBox.get(messageUid);
      getLogger('VideoMedia').wtf('thumbnail added in hive:$path');
    }
  }

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadFile({
    required String messageUid,
    required String filePath,
  }) async {
    var className = 'ChatViewModel';
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    final timestamp = Timestamp.now().millisecondsSinceEpoch;
    final fileType = lookupMimeType(filePath)!.split("/").first;
    String folder =
        fileType == 'image' ? 'Images/IMG-$timestamp' : 'Videos/VID-$timestamp';
    setBusyForObject(_isuploading, true);
    _uploadingMessageUid = messageUid;
    notifyListeners();

    firebase_storage.UploadTask task =
        storage.ref(folder).putFile(File(filePath));

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        getLogger(className).i('Task state: ${snapshot.state}');
        var progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
        _uploadingProgress = progress;
        notifyListeners();

        print('Progress: $_uploadingProgress%');
      },
      onError: (e) {
        getLogger(className).e(task.snapshot);
        if (e.code == 'permission-denied') {
          getLogger(className)
              .i('User does not have permission to upload to this reference.');
        }
      },
    );
    await task;
    String downloadURL = await storage.ref(folder).getDownloadURL();
    getLogger('$className|uploadFile').wtf('File uploaded !!');
    if (!hiveBox.containsKey(messageUid)) {
      hiveBox.put(messageUid, filePath);
    }
    _uploadingMessageUid = null;
    notifyListeners();

    setBusyForObject(_isuploading, false);
    return downloadURL;
  }
}
