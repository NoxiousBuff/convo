import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';

final settingsPod = SettingsPod();

class SettingsPod extends ChangeNotifier {
  String _appTheme = hiveApi.getFromHive(
      HiveApi.appSettingsBoxName, AppSettingKeys.appTheme,
      defaultValue: AppThemes.system);

  ThemeMode get appTheme => stringToThemeMode(_appTheme);

  String get appThemeInString => _appTheme;

  ThemeMode stringToThemeMode(String localAppTheme) {
    switch (localAppTheme) {
      case AppThemes.system:
        {
          return ThemeMode.system;
        }
      case AppThemes.light:
        {
          return ThemeMode.light;
        }
      case AppThemes.dark:
        {
          return ThemeMode.dark;
        }
      default:
        {
          return ThemeMode.system;
        }
    }
  }

  void updateTheme(String appTheme) {
    if (appTheme == _appTheme) return;
    _appTheme = appTheme;
    hiveApi.saveAndReplace(
        HiveApi.appSettingsBoxName, AppSettingKeys.appTheme, appTheme);
    notifyListeners();
  }
}
