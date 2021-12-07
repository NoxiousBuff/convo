import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

class UserAccountViewModel extends BaseViewModel {
  void changeIncognatedMode(bool value) {
    Hive.box(HiveApi.appSettingsBoxName).put(AppSettingKeys.incognatedMode, value);
    notifyListeners();
  }
}