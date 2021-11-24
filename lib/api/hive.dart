import 'package:hive/hive.dart';
import 'package:hint/app/app_logger.dart';

final hiveApi = HiveApi();

class HiveApi {
  final log = getLogger('HiveApi');

  static const String appSettingsBoxName = 'AppSettings';
  static const String recentChatsHiveBox = 'RecentChats';
  Future<void> initialiseHive() async {
    await Hive.openBox(recentChatsHiveBox);
    await Hive.openBox(appSettingsBoxName);
  }

// -----------------------------------------------------------------------------

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
