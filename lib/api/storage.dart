import 'dart:io';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart' ;

final storageApi = StorageApi();

class StorageApi {
  
  /// abstraction of logger for providing logs in
  /// the console for this particular class
  final log = getLogger('StorageApi');

  ///private field [_auth] to get instance of [FirebaseAuth]
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// method to upload a [file] to the storage bucked to [firebase]
   Future<String?> uploadFile(String filePath, String firestorePath, {Function? onError} ) async {
    File file = File(filePath);
    try {
      final uploaded =
          await _storage.ref(firestorePath).putFile(file);
      return await uploaded.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log.e(e.message);
      if(onError != null) onError();
      return null;
    }
  }
}