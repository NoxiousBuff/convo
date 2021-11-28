import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:stacked/stacked.dart';

class AccountViewModel extends BaseViewModel {
  void changeIncognatedMode(bool value) {
    hiveApi.saveInHive(
        HiveApi.appSettingsBoxName, AppSettingKeys.incognatedMode, value);
    notifyListeners();
  }
}