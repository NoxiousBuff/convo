import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hint/app/app_logger.dart';
import 'package:device_info/device_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveApi = HiveApi();

class HiveApi {
  final log = getLogger('HiveApi');
  static const String userContacts = 'userContacts';
  static const String appSettingsBoxName = 'AppSettings';
  static const String recentChatsHiveBox = 'RecentChats';
  static const String userdataHiveBox = 'UserData';
  static const String savedPeopleHiveBox = 'savedPeople';
  static const String recentSearchesHiveBox = 'recentSearches';
  static const String pinnedUsersHiveBox = 'pinnedUsers';
  static const String archivedUsersHiveBox = 'archiveUsers';
  static const String deviceInfoHiveBox = 'deviceInfo';
  Future<void> initialiseHive() async {
    await Hive.openBox(deviceInfoHiveBox);
    await Hive.openBox(appSettingsBoxName);
    await Hive.openBox(pinnedUsersHiveBox);
    await Hive.openBox(userdataHiveBox);
    await Hive.openBox(archivedUsersHiveBox);
    await Hive.openBox(userContacts);
    await Hive.openBox(recentChatsHiveBox);
    await Hive.openBox(savedPeopleHiveBox);
    await Hive.openBox(recentSearchesHiveBox);
  }

  Future<void> saveDeviceInfoInHive() async {
    final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    if(Platform.isAndroid) {
      final build = await _deviceInfoPlugin.androidInfo;
      final deviceVersion = build.version.release;
      saveInHive(deviceInfoHiveBox, 'version', deviceVersion);
    }
  }

// -----------------------------------------------------------------------------

  ValueListenable<Box<dynamic>> hiveStream(String hiveBoxName) {
    return Hive.box(hiveBoxName).listenable();
  }

  dynamic getFromHive(
    String hiveBoxName,
    String key,
  ) {
    try {
      return Hive.box(hiveBoxName).get(key);
    } catch (e) {
      log.e('getFromHive Error:$e');
    }
  }

  dynamic getUserDataWithHive(String key) {
    try {
      return Hive.box(userdataHiveBox).get(key);
    } catch (e) {
      log.e('getFromHive Error:$e');
    }
  }

  dynamic updateUserdateWithHive(String key, dynamic value) {
    try {
      return Hive.box(userdataHiveBox).put(key, value);
    } catch (e) {
      log.e('updateUserFromHive Error:$e');
    }
  }

  void addToSavedPeople(String uid) {
    hiveApi.saveInHive(HiveApi.savedPeopleHiveBox, uid, uid);
    log.wtf('$uid added to saved people');
  }

  void deleteFromSavedPeople(String uid) {
    hiveApi.deleteInHive(HiveApi.savedPeopleHiveBox, uid);
    log.wtf('$uid deleted from saved people');
  }

  void addToPinnedUsers(String uid) {
    hiveApi.saveInHive(HiveApi.pinnedUsersHiveBox, uid, uid);
    log.wtf('$uid added to pinned users');
  }

  void deleteFromPinnedUsers(String uid) {
    hiveApi.deleteInHive(HiveApi.pinnedUsersHiveBox, uid);
    log.wtf('$uid deleted from pinned users');
  }

  void addToArchivedUsers(String uid) {
    hiveApi.saveInHive(HiveApi.archivedUsersHiveBox, uid, uid);
    log.wtf('$uid added to archived users');
  }

  void deleteFromArchivedUsers(String uid) {
    hiveApi.deleteInHive(HiveApi.archivedUsersHiveBox, uid);
    log.wtf('$uid deleted from archived users');
  }

  dynamic doesHiveContain(
    String hiveBoxName,
    String key,
  ) {
    try {
      return Hive.box(hiveBoxName).containsKey(key);
    } catch (e) {
      log.e('getFromHive Error:$e');
    }
  }

  Future<void> deleteInHive(String hiveBoxName, dynamic key) async {
    bool doesBoxExist = await Hive.boxExists(hiveBoxName);
    log.i('doesBoxExists : $doesBoxExist');
    bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
    if (!doesBoxExist && !isBoxOpen) {
      await Hive.openBox(hiveBoxName);
      log.i('Hive box : $hiveBoxName is successfully opened.');
    }
    var openedHiveBox = Hive.box(hiveBoxName);
    openedHiveBox
        .delete(key)
        .then((value) => log.i(
            'The item for the key:$key in hiveBox:$hiveBoxName has been successfully deleted.'))
        .onError((error, stackTrace) => log.e(
            'The value for the key in hiveBox:$hiveBoxName has not been deleted. Error : $error'));
  }

  Future<void> saveAndReplace(
      String hiveBoxName, dynamic key, dynamic value) async {
    Hive.box(hiveBoxName).put(key, value);
    log.wtf('Value:$value');
    log.wtf('Succesfully Replace In Hive');
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
          log.i('Value: $value for key: $key has been successfully completed.');
        }).onError((dynamic error, stackTrace) {
          log.w('Error in saving file path : $error');
        });
      }
    } catch (err) {
      log.w(
          'Error in opening hive box: $hiveBoxName.This is the following error : $err');
    }
  }
}
