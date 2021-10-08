// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MessageBubbleViewModel extends BaseViewModel {
  final conversation = FirebaseFirestore.instance.collection(convoFirestorekey);

  firebase_storage.TaskState? _taskState;
  firebase_storage.TaskState? get taskState => _taskState;

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  firebase_storage.UploadTask? _task;
  firebase_storage.UploadTask? get task => _task;

  bool _isuploading = false;
  bool get isuploading => _isuploading;

  bool _isDataUploading = false;
  bool get isDataUploading => _isDataUploading;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> updateMediaDocument(
      {required String conversationId,
      required String messageUid,
      required String downloadURL}) async {
    FirebaseFirestore.instance
        .collection(convoFirestorekey)
        .doc(conversationId)
        .collection(chatsFirestoreKey)
        .doc(messageUid)
        .set({
      'message': {
        MessageField.mediaURL: downloadURL,
        MessageField.uploaded: true,
      },
    }, SetOptions(merge: true)).catchError((e) {
      getLogger('MessageBubble_viewModel').e('update Message:$e');
    });
  }

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadFile({
    required String filePath,
    required String messageUid,
    required String conversationId,
  }) async {
    var now = DateTime.now();
    var className = 'MessageBubbleViewModel';
    var firebasStorageFileName =
        '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}${now.microsecond}';
    final fileType = lookupMimeType(filePath)!.split("/").first;
    String folder = fileType == imageType
        ? 'Images/IMG-$firebasStorageFileName'
        : 'Videos/VID-$firebasStorageFileName';

    firebase_storage.UploadTask task =
        storage.ref(folder).putFile(File(filePath));

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        getLogger(className).i('Task state: ${snapshot.state}');
        var progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
        _isuploading = true;
        _taskState = snapshot.state;
        _uploadingProgress = progress;
        notifyListeners();
        print('UploadingProgress: $_uploadingProgress%');
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

    await updateMediaDocument(
            messageUid: messageUid,
            downloadURL: downloadURL,
            conversationId: conversationId)
        .then((value) => getLogger(className).wtf('Media Message Updated'))
        .catchError((e) {
      getLogger(className).wtf('uploadFile| updating Media Message:$e');
    });

    getLogger(className).wtf('Video uploaded !!');
    _isuploading = false;
    return downloadURL;
  }

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadData({
    required Uint8List data,
    required String messageUid,
    required String conversationId,
  }) async {
    var className = 'MessageBubbleViewModel';
    final timestamp = Timestamp.now().millisecondsSinceEpoch;
    String folder = 'Images/CanvasIMG-$timestamp';

    firebase_storage.UploadTask task = storage.ref(folder).putData(data);

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        getLogger(className).i('Task state: ${snapshot.state}');
        var progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
        _isDataUploading = true;
        _taskState = snapshot.state;
        _uploadingProgress = progress;
        notifyListeners();
        print('UploadingProgress: $_uploadingProgress%');
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

    await updateMediaDocument(
            messageUid: messageUid,
            downloadURL: downloadURL,
            conversationId: conversationId)
        .then((value) => getLogger(className).wtf('Media Message Updated'))
        .catchError((e) {
      getLogger(className).wtf('uploadFile| updating Media Message:$e');
    });

    _isDataUploading = false;
    return downloadURL;
  }

  void onError(error) {
    getLogger('MessageBubbleViewModel onError').e(error);
  }
}
