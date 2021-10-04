// ignore_for_file: avoid_print

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MessageBubbleViewModel extends BaseViewModel {
  final String conversationId;
  MessageBubbleViewModel(this.conversationId);

  firebase_storage.TaskState? _taskState;
  firebase_storage.TaskState? get taskState => _taskState;

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  final bool _isuploading = false;
  bool get isuploading => _isuploading;

  String? _uploadingMessageUid;
  String? get uploadingMessageUid => _uploadingMessageUid;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadFile({
    required String messageUid,
    required String filePath,
  }) async {
    setBusyForObject(_isuploading, true);
    var className = 'MessageBubbleViewModel';
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    final timestamp = Timestamp.now().millisecondsSinceEpoch;
    final fileType = lookupMimeType(filePath)!.split("/").first;
    String folder =
        fileType == 'image' ? 'Images/IMG-$timestamp' : 'Videos/VID-$timestamp';
    

    getLogger('MessageBubble').wtf('isUploading Start:${busy(_isuploading)}');
    firebase_storage.UploadTask task =
        storage.ref(folder).putFile(File(filePath));

    // _taskState = task.snapshot.state;
    // notifyListeners();

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

    // _taskState = null;
    // notifyListeners();

    setBusyForObject(_isuploading, false);
    getLogger('MessageBubble').wtf('isUploading End:${busy(_isuploading)}');
    return downloadURL;
  }

  void onError(error) {
    getLogger('MessageBubbleViewModel onError').e(error);
  }
}
