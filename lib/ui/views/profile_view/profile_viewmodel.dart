import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/message_string.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileViewModel extends BaseViewModel {
  final log = getLogger('ProfileViewModel');

  final bool _isUploading = false;
  bool get isUploading => _isUploading;

  int? value;

  void currentIndex(int? i) {
    value = i;
    notifyListeners();
  }

  List<String> optionName = [
    'For 15 Minutes',
    'For 1 Hour',
    'For 8 Hours',
    'For 24 Hours',
    'Until I turn it back on'
  ];

  /// Clicking Image from camera
  Future<File?> pickImage(ImageSource imageSource) async {
    final selectedImage = await ImagePicker().pickImage(source: imageSource);

    if (selectedImage != null) {
      return File(selectedImage.path);
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> updateMediaDocument(
      {required String fireUserId, required String downloadURL}) async {
    FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(fireUserId)
        .set({
      'message': {UserField.photoURL: downloadURL},
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
    var firstPart = '${now.year}${now.month}${now.day}';
    var secondPart = '${now.hour}${now.minute}${now.second}';

    final profileImage = 'IMG-$firstPart-P$secondPart';

    firebase_storage.UploadTask task =
        storage.ref('ProfileImages/$profileImage').putFile(File(filePath));

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        log.i('Task state: ${snapshot.state}');
        var progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
        setBusyForObject(_isUploading, true);

        log.i('UploadingProgress: $progress%');
      },
      onError: (e) {
        log.e(task.snapshot);
        if (e.code == 'permission-denied') {
          log.i('User does not have permission to upload to this reference.');
        }
      },
    );
    await task;
    String downloadURL =
        await storage.ref('ProfileImages/$profileImage').getDownloadURL();

    await updateMediaDocument(
            downloadURL: downloadURL, fireUserId: conversationId)
        .then((value) => log.wtf('Profile Image Updated'))
        .catchError((e) {
      log.wtf('uploadFile| updating ProfileImage:$e');
    });

    log.wtf('Video uploaded !!');
    setBusyForObject(_isUploading, false);
    return downloadURL;
  }
}
