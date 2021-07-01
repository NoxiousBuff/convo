import 'dart:io';

import 'package:hive/hive.dart';

class HiveHelper {
  static const String hiveBoxImages = 'ImagesHiveBox';
  static const String hiveBoxAudio = 'AudioHiveBox';
  static const String hiveBoxVideo = 'VideosHiveBox';
  static const String hiveBoxDocs = 'DocumentsHiveBox';
  static const String hiveBoxThumbnails = 'ThumbnailsHiveBox';
  static const String hiveBoxProfilePhotos = 'ProfilePhotosHiveBox';
  Future<void> initialiseHive() async {
    await Hive.openBox(hiveBoxProfilePhotos);
    await Hive.openBox(hiveBoxThumbnails);
    await Hive.openBox(hiveBoxImages);
    await Hive.openBox(hiveBoxVideo);
    await Hive.openBox(hiveBoxAudio);
    await Hive.openBox(hiveBoxDocs);
  }

  Future<void> saveFilePathInHive({
    required String hiveBoxName,
    required String key,
    required String filePath,
  }) async {
    try {
      bool doesBoxExist = await Hive.boxExists(hiveBoxName);
      print('doesBoxExists : $doesBoxExist');
      bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
      print('isBoxOpen : $isBoxOpen');
      if (!doesBoxExist && !isBoxOpen) {
        await Hive.openBox(hiveBoxName);
        print('Hive box : $hiveBoxName is successfully opened.');
      }
      var openedHiveBox = Hive.box(hiveBoxName);
      if (!openedHiveBox.containsKey(key)) {
        await openedHiveBox
            .put(key, filePath)
            .onError((dynamic error, stackTrace) {
          print('Error in saving file path : $error');
          saveFilePathInHive(
              hiveBoxName: hiveBoxName, key: key, filePath: filePath);
        });
      } else if (!await File(openedHiveBox.get(key)).exists()) {
        await openedHiveBox
            .put(key, filePath)
            .onError((dynamic error, stackTrace) {
          print('Error in saving file path : $error');
          saveFilePathInHive(
              hiveBoxName: hiveBoxName, key: key, filePath: filePath);
        });
      }
      String? hiveValue = Hive.box(hiveBoxName).get(key);
      //todo remove
      print(
          'This is the value : $hiveValue save in hiveBox : $hiveBoxName for Key : $key');
    } catch (err) {
      print(
          'Error in opening hive box: $hiveBoxName.This is the following error : $err');
    }
  }
}
