import 'dart:io';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

final storageApi = StorageApi();

class StorageApi {
  /// abstraction of logger for providing logs in
  /// the console for this particular class
  final log = getLogger('StorageApi');

  ///private field [_auth] to get instance of [FirebaseAuth]
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _firebaseStorage = firebase_storage.FirebaseStorage.instance;

  /// method to upload a [file] to the storage bucked to [firebase]
  Future<String?> uploadFile(String filePath, String firestorePath,
      {Function? onError}) async {
    File file = File(filePath);
    try {
      final uploaded = await _storage.ref(firestorePath).putFile(file);

      return await uploaded.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log.e(e.message);
      if (onError != null) onError();
      return null;
    }
  }

  Future<String> uploadMedia(String filePath, String firestorePath) async {
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(firestorePath)
        .putFile(File(filePath));
    try {
      task.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        log.v(progress);
      });

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
      // ...

    }
    final downloadURL = _firebaseStorage.ref(firestorePath).getDownloadURL();
    return downloadURL;
  }
}
