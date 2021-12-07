import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';

class UpdateEmailViewModel extends BaseViewModel {
  final log = getLogger('UpdatEmailViewModel');

  final updateEmailFormKey = GlobalKey<FormState>();
  final TextEditingController upadteEmailTech = TextEditingController();

  bool _isDisplayNameEmpty = true;
  bool get isDisplayNameEmpty => _isDisplayNameEmpty;

  void updateDisplayNameEmpty() {
    _isDisplayNameEmpty = upadteEmailTech.text.isEmpty;
    notifyListeners();
  } 

  Future<void> updateUserEmail(BuildContext context, String email) async {
    setBusy(true);
    try {
      final user = AuthService.liveUser;
      await emailExists(email);
      await firestoreApi
          .updateUser(
              uid: user!.uid, value: email, propertyName: FireUserField.email)
          .whenComplete(() => customSnackbars.successSnackbar(context,
              title: 'Email successfully updated'))
          .catchError((e) {
        setBusy(false);
        customSnackbars.errorSnackbar(context, title: 'Something went wrong');
      });
      await hiveApi.saveAndReplace(
          HiveApi.userdataHiveBox, FireUserField.email, email);
    } catch (e) {
      log.e('Update Email Error:$e');
    }
    setBusy(false);
  }

  Future<bool> emailExists(String email) async {
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (list.isEmpty) {
      log.wtf('Email not exists');
      return false;
    } else {
      setBusy(false);
      log.wtf('Email  exists');
      return true;
    }
  }

  @override
  dispose() {
    upadteEmailTech.dispose();
    super.dispose();
  }
}
