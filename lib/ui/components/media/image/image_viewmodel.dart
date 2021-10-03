// ignore_for_file: avoid_print

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageViewModel extends BaseViewModel {
  final String conversationId;
  ImageViewModel(this.conversationId);

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  final bool _isuploading = false;
  bool get isuploading => _isuploading;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadFile({
    required String messageUid,
    required String filePath,
  }) async {
    var className = 'MessageBubbleViewModel';
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    final timestamp = Timestamp.now().millisecondsSinceEpoch;
    final fileType = lookupMimeType(filePath)!.split("/").first;
    String folder =
        fileType == 'image' ? 'Images/IMG-$timestamp' : 'Videos/VID-$timestamp';
    setBusyForObject(_isuploading, true);
   
    
    getLogger('MessageBubble').wtf('isUploading Start:$_isuploading');
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
  

    setBusyForObject(_isuploading, false);
    getLogger('MessageBubble').wtf('isUploading End:$_isuploading');
    return downloadURL;
  }
}
