import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeDobViewModel extends BaseViewModel {
  final log = getLogger('ChangeDobViewModel');

  DateTime _dob = DateTime.now();
  DateTime get dob => _dob;

  void updateDob(DateTime localDob) {
    _dob = localDob;
    notifyListeners();
  }

  bool get isDobNull => hiveApi.getUserDataWithHive(FireUserField.dob) == null;

  int get dobInMilliseconds => _dob.millisecondsSinceEpoch;

  int _age = 18;
  int get age => _age;

  void updateAge(DateTime birthDate) {
    final today = DateTime.now();
    final ageInDays = today.difference(birthDate).inDays;
    final ageInYears = ageInDays / 365;
    _age = ageInYears.toInt();
    notifyListeners();
  } 

  String _formattedBirthDate = 'Error In Fetching Your Date of Birth';
  String get formattedBirthDate => _formattedBirthDate;

  void birthDateFormatter() {
    final birthDateInMilliseconds = hiveApi.getUserDataWithHive(FireUserField.dob); 
    if(birthDateInMilliseconds != null) {
      final dobAsInt = birthDateInMilliseconds as int;
      String dateFormat = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(dobAsInt));
      _formattedBirthDate = dateFormat;
      notifyListeners();
    }
  }

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