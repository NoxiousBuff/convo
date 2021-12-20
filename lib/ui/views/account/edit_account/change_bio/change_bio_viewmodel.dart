import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeBioViewModel extends BaseViewModel {
  final log = getLogger('ChangeBioViewModel');

  final TextEditingController bioNameTech = TextEditingController();

  final firestoreApi = locator<FirestoreApi>();

  bool _isBioNameEmpty = true;
  bool get isBioNameEmpty => _isBioNameEmpty;

  void updateBioNameEmpty() {
    _isBioNameEmpty = bioNameTech.text.isEmpty;
    notifyListeners();
  }

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  void updateIsEdited(bool localIsEdited) {
    _isEdited = localIsEdited;
    notifyListeners();
  } 
  
  bool get isActive => !_isBioNameEmpty && isEdited; 

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