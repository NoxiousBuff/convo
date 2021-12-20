import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/extensions/query.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeUserNameViewModel extends BaseViewModel {
  final log = getLogger('ChangeUserNameViewModel');

  final TextEditingController userNameTech = TextEditingController();

  bool _isUserNameEmpty = true;
  bool get isUserNameEmpty => _isUserNameEmpty;

  UserNameExists _doesExists = UserNameExists.didNotChecked;
  UserNameExists get doesExists => _doesExists;

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
final firestoreApi = locator<FirestoreApi>();
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

  void findUsernameExistOrNot(String value) async {
    if(value.length > 3) {
      _doesExists = UserNameExists.checking;
    notifyListeners();
    final snapshotData = await FirebaseFirestore.instance.collection(subsFirestoreKey).where(FireUserField.username, isEqualTo: value).getSavy();
    final doc = snapshotData.docs;
    if(doc.isNotEmpty) {
      _doesExists = UserNameExists.no;
    } else {
      _doesExists = UserNameExists.yes;
    }
    log.wtf(doc.toString());
    log.wtf(_doesExists);
    notifyListeners();
    } else {
      _doesExists = UserNameExists.tooShort;
      notifyListeners();
    }
  }

}