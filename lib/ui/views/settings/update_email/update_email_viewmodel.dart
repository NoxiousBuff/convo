import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
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

  final firestoreApi = locator<FirestoreApi>();

  final TextEditingController passwordTech = TextEditingController();
  final TextEditingController upadteEmailTech = TextEditingController();

  bool _isDisplayNameEmpty = true;
  bool get isDisplayNameEmpty => _isDisplayNameEmpty;

  bool _isPasswordEmpty = true;
  bool get isPasswordEmpty => _isPasswordEmpty;

  void updateDisplayNameEmpty() {
    _isDisplayNameEmpty = upadteEmailTech.text.isEmpty;
    notifyListeners();
  }

  void updatePasswordEmpty() {
    _isPasswordEmpty = passwordTech.text.isEmpty;
    notifyListeners();
  }

  Future<void> updateUserEmail(
      BuildContext context, String email, String password) async {
    setBusy(true);
    String key = FireUserField.email;

    User? user = AuthService.liveUser;
    bool isExists = await emailExists(email);
    const hiveBox = HiveApi.userDataHiveBox;
    String currentEmail = hiveApi.getFromHive(hiveBox, key);
    try {
      switch (isExists) {
        case false:
          {
            if (user != null) {
              String uid = user.uid;
              const title = 'Email successfully updated';
              AuthCredential credential = EmailAuthProvider.credential(
                  email: currentEmail, password: password);
              await FirebaseAuth.instance.signInWithCredential(credential);
              await user.updateEmail(email);

              firestoreApi
                  .updateUser(uid: uid, value: email, propertyName: key)
                  .whenComplete(() {
                hiveApi.saveAndReplace(hiveBox, key, email);
                customSnackbars.successSnackbar(context, title: title);
              });
            } else {
              setBusy(false);
              log.w('User Is Currently Null Now');
              const title = 'something went wrong';
              customSnackbars.errorSnackbar(context, title: title);
            }
          }

          break;
        case true:
          {
            setBusy(false);
            const title = 'This Email Is Already In User';
            customSnackbars.infoSnackbar(context, title: title);
          }
          break;
        default:
      }
    } catch (e) {
      log.e('Update Email Error:$e');
      customSnackbars.errorSnackbar(context, title: 'something went wrong');
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
    passwordTech.dispose();
    super.dispose();
  }
}