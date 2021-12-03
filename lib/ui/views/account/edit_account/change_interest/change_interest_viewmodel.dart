import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeInterestViewModel extends BaseViewModel {
  final log = getLogger('ChangeInterestViewModel');

  bool isSelected = false;
  List<dynamic> _userInterests = [];
  List<dynamic> get userInterests => _userInterests;

  void gettingInterests() {
    _userInterests =
        Hive.box(HiveApi.userdataHiveBox).get(FireUserField.interests);
    notifyListeners();
    log.wtf('Userinterests:$_userInterests');
  }

  Future<void> saveData(BuildContext context) async {
    setBusy(true);
    await firestoreApi.updateUser(
      uid: AuthService.liveUser!.uid,
      value: _userInterests,
      propertyName: FireUserField.interests,
    );
    await hiveApi.updateUserdateWithHive(
        FireUserField.interests, _userInterests);
    setBusy(false);
    customSnackbars.successSnackbar(context,
        title: 'You Data Was Sucessfully Saved');
    Navigator.pop(context);
  }
}