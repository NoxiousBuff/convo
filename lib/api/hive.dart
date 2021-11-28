import 'package:flutter/foundation.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveApi = HiveApi();

class HiveApi {
  final log = getLogger('HiveApi');
  static const String appSettingsBoxName = 'AppSettings';
  static const String recentChatsHiveBox = 'RecentChats';
  static const String userdataHiveBox = 'UserData';
  Future<void> initialiseHive() async {
    await Hive.openBox(appSettingsBoxName);
    await Hive.openBox(recentChatsHiveBox);
    await Hive.openBox(userdataHiveBox);
  }

// -----------------------------------------------------------------------------

  ValueListenable<Box<dynamic>> hiveStream(String hiveBoxName) {
    return Hive.box(hiveBoxName).listenable();
  }

   dynamic getFromHive(String hiveBoxName, String key, ) {
    try {
     return Hive.box(hiveBoxName).get(key);
    } catch (e) {
      log.e('getFromHive Error:$e');
    }
  }

  Future<void> deleteInHive(String hiveBoxName, dynamic key) async {
    bool doesBoxExist = await Hive.boxExists(hiveBoxName);
    getLogger('HiveApi').i('doesBoxExists : $doesBoxExist');
    bool isBoxOpen = Hive.isBoxOpen(hiveBoxName);
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
}
