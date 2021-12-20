import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeDisplayNameViewModel extends BaseViewModel {
  final log = getLogger('ChangeDisplayNameViewModel');

  final TextEditingController dispayNameTech = TextEditingController();

  bool _isDisplayNameEmpty = true;
  bool get isDisplayNameEmpty => _isDisplayNameEmpty;

  final firestoreApi = locator<FirestoreApi>();

  void updateDisplayNameEmpty() {
    _isDisplayNameEmpty = dispayNameTech.text.isEmpty;
    notifyListeners();
  }

  bool get isActive => !_isDisplayNameEmpty && isEdited;

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
      hiveApi.updateUserData(propertyName, value);
      customSnackbars.successSnackbar(context,
          title: 'Succeesfully Saved !!');
    });
    setBusy(false);
    Navigator.of(context, rootNavigator: false).pop();
  }

}