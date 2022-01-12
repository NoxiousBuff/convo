import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeDobViewModel extends BaseViewModel {
  final log = getLogger('ChangeDobViewModel');

  DateTime _dob = DateTime.now();
  DateTime get dob => _dob;

  void updateDob(DateTime localDob) {
    _dob = localDob;
    notifyListeners();
  }

  bool get isDobNull => hiveApi.getUserData(FireUserField.dob) == null;

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
    final birthDateInMilliseconds = hiveApi.getUserData(FireUserField.dob); 
    if(birthDateInMilliseconds != null) {
      final dobAsInt = birthDateInMilliseconds as int;
      final dobAsDateTime = DateTime.fromMillisecondsSinceEpoch(dobAsInt);
      final jiffyFormattedDate = Jiffy(dobAsDateTime).format("MMM do yyyy");
      _formattedBirthDate = jiffyFormattedDate;
      notifyListeners();
    }
  }

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

  Future<void> openEmailClientForChangeDOB(BuildContext context) async {
    String username = hiveApi.getUserData(FireUserField.username, defaultValue: '');
    final url = 'mailto:support@theconvo.in?subject=Change%20my%20birth%20date&body=Add%20your%20content%20here%0A%0A%0A%0AThanks,%0A$username';
    if (! await launch(url)) customSnackbars.errorSnackbar(context, title: 'Error in opening email client.');
  }

}