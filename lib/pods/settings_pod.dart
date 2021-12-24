import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';

final settingsPod = ChangeNotifierProvider((ref) => SettingsPod());

class SettingsPod extends ChangeNotifier {
  bool _isDarkTheme =
      hiveApi.getFromHive(HiveApi.appSettingsBoxName, AppSettingKeys.darkTheme);
  bool get isDarkTheme => _isDarkTheme;

  void updateThme(bool localIsDarkTheme) {
    if (localIsDarkTheme == _isDarkTheme) return;
    _isDarkTheme = localIsDarkTheme;
    hiveApi.saveAndReplace(
        HiveApi.appSettingsBoxName, AppSettingKeys.darkTheme, localIsDarkTheme);
  }
}
