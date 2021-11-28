import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final userAccountProvider = ChangeNotifierProvider((ref) => AccountViewModel());

class AccountViewModel extends ChangeNotifier {
  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _fileUrl;
  String? get fileUrl => _fileUrl;

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  // upload image into firebase storage
  Future<void> uploadImage() async {
    File largeFile = File(_pickedImage!.path);
    final currentTime = DateTime.now();
    String folder = 'profilePhoto/$currentTime';
    _isUploading = true;
    notifyListeners();
    getLogger('accountViewModel').i('isUploading:$_isUploading');

    firebase_storage.UploadTask task = _storage.ref(folder).putFile(largeFile);

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        getLogger('accountViewModel').i('Task state: ${snapshot.state}');
        getLogger('accountViewModel').i(progress);
      },
      onError: (e) {
        getLogger('accountViewModel').e(task.snapshot);

        if (e.code == 'permission-denied') {
          getLogger('accountViewModel')
              .e('User does not have permission to upload to this reference.');
        }
      },
    );

    await task.whenComplete(() async {
      final url = await _storage.ref(folder).getDownloadURL();
      _fileUrl = url;
      notifyListeners();
    });
  }

// image_picker for click image from camera
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage =
          await ImagePicker().pickImage(source: source);
      _pickedImage = File(selectedImage!.path);
      _isUploading = true;
      notifyListeners();
    } catch (e) {
      getLogger('accountViewModel|pickImage').e(e);
    }
  }

  Future<void> updatePhoto(String id) async {
    CollectionReference subsCollection = FirebaseFirestore.instance.collection(subsFirestoreKey);

    subsCollection
        .doc(id)
        .update({'photoUrl': _fileUrl!})
        .then(
            (value) => getLogger('accountViewModel').i("ProfilePhoto Updated"))
        .catchError((error) =>
            getLogger('accountViewModel').e("Failed to update user: $error"));
  }
}
