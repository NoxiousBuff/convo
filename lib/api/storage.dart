import 'dart:io';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

class StorageApi {
  FirebaseStorage storage =
      FirebaseStorage.instance;

  final log = getLogger('StorageApi');

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      log.e(e);
    }
  }

  Future<void> uploadFilesList(List<String> filePathList) async {
    for (String filePath in filePathList) {
      await uploadFile(filePath);
    }
  }

  Future<void> uploadString() async {
    String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';

    try {
      await FirebaseStorage.instance
          .ref('uploads/hello-world.text')
          .putString(dataUrl, format: PutStringFormat.dataUrl);
    } on FirebaseException catch (e) {
      if (e.code == 'canceled') {
        log.e('The process has been cancelled.');
      }
      log.e('Error comes in uploading string : $e');
    }
  }

  Future<void> uploadData() async {
    String text = 'Hello World!';
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);

    Reference ref = FirebaseStorage.instance
        .ref('uploads/hello-world.text');

    try {
      // Upload raw data.
      await ref.putData(data);
      // Get raw data.
      Uint8List? downloadedData = await ref.getData();
      // prints -> Hello World!
      getLogger('StorageApi').wtf(utf8.decode(downloadedData!));
    } on FirebaseException catch (e) {
      if (e.code == 'canceled') {
        log.e('The process has been cancelled.');
      }
      log.e('Error comes in uploading string : $e');
    }
  }

  Future<String> getDownloadURL(String ref) async {
    Future<String> downloadURL =
        FirebaseStorage.instance.ref(ref).getDownloadURL();
    return downloadURL;
  }
}