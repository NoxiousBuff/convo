import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeUserNameViewModel extends BaseViewModel {
  final log = getLogger('ChangeUserNameViewModel');

  final TextEditingController userNameTech = TextEditingController();

  bool _isUserNameEmpty = true;
  bool get isUserNameEmpty => _isUserNameEmpty;

  void updateUserNameEmpty() {
    _isUserNameEmpty = userNameTech.text.isEmpty;
    notifyListeners();
  }

  bool get isActive => !_isUserNameEmpty && _isEdited;

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  void updateIsEdited(bool localIsEdited) {
    _isEdited = localIsEdited;
    notifyListeners();
  } 

  Future<void> updateUserProperty(BuildContext context, String propertyName, dynamic value) async {
    setBusy(true);
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: value,
      propertyName: propertyName,
    )
        .then((instance) {
      hiveApi.updateUserdateWithHive(propertyName, value);
      customSnackbars.successSnackbar(context,
          title: 'Succeesfully Saved !!');
    });
    setBusy(false);
    Navigator.of(context, rootNavigator: false).pop();
  }

}