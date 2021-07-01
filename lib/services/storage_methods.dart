import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageMethods {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await firebaseStorage.ref('uploads/file-to-upload.png').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Error in uploading File via uploadFile: $e');
    }
  }
}
