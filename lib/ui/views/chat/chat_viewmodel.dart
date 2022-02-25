import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmo_media_picker/media_picker.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class ChatViewModel extends BaseViewModel {
  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  final log = getLogger('ChatViewModel');
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  static final CollectionReference _conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  double? _uploadingFileProgress;
  double? get fileProgress => _uploadingFileProgress;

  String _uploadingFileTitle = '';
  String get fileTitle => _uploadingFileTitle;

  // ignore: prefer_final_fields
  List<String> _selectedMediaList = [];
  List<String> get selectedMediaList => _selectedMediaList;

  void changeTitle(String title) {
    _uploadingFileTitle = title;
    notifyListeners();
  }

  /// add into media list
  void addToMediaList(String url) => _selectedMediaList.add(url);

  /// clear the media list
  void clearTheList() => _selectedMediaList.clear();

  /// Reset the current progress of file after uploading
  void updateProgress(double? value) {
    _uploadingFileProgress = value;
    notifyListeners();
  }

  /// upload media into firebase storage and get progress
  Future<String> uploadFile(
      String filePath, String firestorePath, String mediaType) async {
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(firestorePath)
        .putFile(File(filePath));
    try {
      task.snapshotEvents.listen(
        (snapshot) {
          var progress = snapshot.bytesTransferred / snapshot.totalBytes;
          log.v((snapshot.bytesTransferred / snapshot.totalBytes) * 100);

          updateProgress(progress);
        },
      );

      // Storage tasks function as a Delegating Future so we can await them.
      //firebase_storage.TaskSnapshot snapshot = await task;
      //log.wtf(snapshot.bytesTransferred / snapshot.totalBytes);
      //print('Uploaded ${snapshot.bytesTransferred} bytes.');

    } on firebase_core.FirebaseException catch (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      log.wtf(task.snapshot);

      if (e.code == 'permission-denied') {
        log.e('User does not have permission to upload to this reference.');
      }
    }
    await task;
    String downloadURL = await _storage.ref(firestorePath).getDownloadURL();
    addMediaMessage(mediaType, downloadURL);
    return downloadURL;
  }

  /// Genrate File Name For Firebase Storage Bucket 
  /// and upload to firebase storage and add to firestore
  Future<String> uploadAndAddToDatabase(AssetEntity asset) async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    final mimeType = asset.mimeType!.split("/").first;
    final fileExtension = asset.mimeType!.split("/").last;

    String storagePath = mimeType == 'image'
        ? 'IMG-$uploadingDate-$uploadingTime.$fileExtension'
        : 'VID-$uploadingDate-$uploadingTime.$fileExtension';

    final date = DateFormat('yMMMMd').format(now);
    final firebasePath = 'ChatMedia/$date/$storagePath';

    log.v(asset.mimeType);
    log.v('MimeType:$mimeType | FileExtension:$fileExtension');
    log.v('FirebaseStoragePath:$storagePath');

    File? file = await asset.file;

    return uploadFile(file!.path, firebasePath, mimeType);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getUserchat =>
      _conversationCollection
          .doc(conversationId)
          .collection(chatsFirestoreKey)
          .orderBy(DocumentField.timestamp, descending: true)
          .snapshots();

  String _messageText = '';
  String get messageText => _messageText;

  void updateMessageText(String value) {
    _messageText = value.trim();
    notifyListeners();
  }

  Future<void> updateUserDataWithKey(String key, dynamic value) =>
      databaseService.updateUserDataWithKey(key, value);

  Stream<DatabaseEvent> get realtimeDBDocument => FirebaseDatabase.instance
      .ref()
      .child(dulesRealtimeDBKey)
      .child(fireUser.id)
      .onValue;

  addMessage() {
    messageTech.clear();
    updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    chatService.addNewMessage(
        receiverUid: fireUser.id,
        type: MediaType.text,
        messageText: _messageText);
    updateMessageText('');
  }

  void addMediaMessage(String mediaType, String mediaUrl) {
    chatService.addNewMessage(
        receiverUid: fireUser.id, type: mediaType, mediaUrl: mediaUrl);
  }

  final TextEditingController messageTech = TextEditingController();

  @override
  void dispose() {
    databaseService.updateUserDataWithKey(DatabaseMessageField.roomUid, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    databaseService.updateUserDataWithKey(DatabaseMessageField.url, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.urlType, '');
    super.dispose();
  }
}
