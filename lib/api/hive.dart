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
  static const String hiveBoxLinkData = 'LinkDataHiveBox';
  static const String hiveBoxMultiMedia = 'MultiMediaHiveBox';
  static const String hiveBoxEmojies = 'EmojiesHiveBox';
  Future<void> initialiseHive() async {
    await Hive.openBox(hiveBoxProfilePhotos);
    await Hive.openBox(hiveBoxThumbnails);
    await Hive.openBox(hiveBoxImages);
    await Hive.openBox(hiveBoxVideo);
    await Hive.openBox(hiveBoxAudio);
    await Hive.openBox(hiveBoxDocs);
    await Hive.openBox(hiveBoxLinkData);
    await Hive.openBox(hiveBoxMultiMedia);
    await Hive.openBox(hiveBoxEmojies);
  }

  Future<dynamic> getFromHive(String hiveBoxName, dynamic key) async {
    bool doesBoxExist = await Hive.boxExists(hiveBoxName);
    bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
    if (!doesBoxExist && !isBoxOpen) {
      await Hive.openBox(hiveBoxName);
    }
    var openedHiveBox = Hive.box(hiveBoxName);
    final value = openedHiveBox
        .get(key)
        .then((value) => log.i(
            'The item for the key:$key in the hiveBox:$hiveBoxName has been successfully retrieved.'))
        .onError((error, stackTrace) => log
            .e('The value for the key has not been retrieved. Error : $error'));
    return value;
  }

  Future<void> deleteInHive(String hiveBoxName, dynamic key) async {
    bool doesBoxExist = await Hive.boxExists(hiveBoxName);
    getLogger('HiveApi').i('doesBoxExists : $doesBoxExist');
    bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
    //getLogger('HiveApi').i('isBoxOpen : $isBoxOpen');
    if (!doesBoxExist && !isBoxOpen) {
      await Hive.openBox(hiveBoxName);
      getLogger('HiveApi').i('Hive box : $hiveBoxName is successfully opened.');
    }
    var openedHiveBox = Hive.box(hiveBoxName);
    openedHiveBox
        .delete(key)
        .then((value) => log.i(
            'The item for the key:$key in hiveBox:$hiveBoxName has been successfully deleted.'))
        .onError((error, stackTrace) => log.e(
            'The value for the key in hiveBox:$hiveBoxName has not been deleted. Error : $error'));
  }

  Future<void> saveInHive(
      String hiveBoxName, dynamic key, dynamic value) async {
    try {
      bool doesBoxExist = await Hive.boxExists(hiveBoxName);
      bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
      if (!doesBoxExist && !isBoxOpen) {
        await Hive.openBox(hiveBoxName);
      }
      var openedHiveBox = Hive.box(hiveBoxName);
      if (!openedHiveBox.containsKey(key)) {
        await openedHiveBox.put(key, value).then((instance) {
          getLogger('HiveApi').i(
              'Value: $value for key: $key has been successfully completed.');
        }).onError((dynamic error, stackTrace) {
          getLogger('HiveApi').w('Error in saving file path : $error');
        });
      }
    } catch (err) {
      getLogger('HiveApi').w(
          'Error in opening hive box: $hiveBoxName.This is the following error : $err');
    }
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
