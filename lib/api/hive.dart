import 'dart:io';
import 'package:hint/app/app_logger.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  final log = getLogger('HiveApi');

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
      log.wtf('doesBoxExists : $doesBoxExist');
      bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
      log.wtf('isBoxOpen : $isBoxOpen');
      if (!doesBoxExist && !isBoxOpen) {
        await Hive.openBox(hiveBoxName);
        log.i('Hive box : $hiveBoxName is successfully opened.');
      }
      var openedHiveBox = Hive.box(hiveBoxName);
      if (!openedHiveBox.containsKey(key)) {
        await openedHiveBox
            .put(key, filePath)
            .onError((dynamic error, stackTrace) {
              log.e('Error in saving file path : $error');
          saveFilePathInHive(
              hiveBoxName: hiveBoxName, key: key, filePath: filePath);
        });
      } else if (!await File(openedHiveBox.get(key)).exists()) {
        await openedHiveBox
            .put(key, filePath)
            .onError((dynamic error, stackTrace) {
          log.e('Error in saving file path : $error');
          saveFilePathInHive(
              hiveBoxName: hiveBoxName, key: key, filePath: filePath);
        });
      }
      String? hiveValue = Hive.box(hiveBoxName).get(key);
      //todo remove
      log.i(
          'This is the value : $hiveValue save in hiveBox : $hiveBoxName for Key : $key');
    } catch (err) {
      log.e(
          'Error in opening hive box: $hiveBoxName.This is the following error : $err');
    }
  }
}
