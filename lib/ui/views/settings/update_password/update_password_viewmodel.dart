import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';

class UpdatePasswordViewModel extends BaseViewModel {
  final log = getLogger('UpdatePasswordViewModel');

  final resetPasswordFormKey = GlobalKey<FormState>();

  bool _passwordNotEmpty = false;
  bool get passwordNotEmpty => _passwordNotEmpty;

  bool _newpasswordNotEmpty = false;
  bool get newPasswordNotEmpty => _newpasswordNotEmpty;

  final TextEditingController _passwordTech = TextEditingController();
  TextEditingController get passwordTech => _passwordTech;

  final TextEditingController _newPasswordTech = TextEditingController();
  TextEditingController get newPasswordTech => _newPasswordTech;

  final AuthService _authService = AuthService();

  void updatePasswordEmpty() {
    _passwordNotEmpty = _passwordTech.text.isNotEmpty;
    notifyListeners();
  }

  void updateNewPasswordEmpty() {
    _newpasswordNotEmpty = _newPasswordTech.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    setBusy(true);
    await _authService.forgotPassword(
      email,
      onComplete: () {
        customSnackbars.successSnackbar(context,
            title:
                'You have been sent a password reset email successfully. Check you inbox.');
      },
      onError: () {
        customSnackbars.errorSnackbar(context,
            title:
                'Something went wrong. Please check your internet connection.');
      },
      noAccountExists: () {
        customSnackbars.errorSnackbar(context,
            title:
                'No user found with this email. Please check you email again.');
      },
      invalidEmailAddress: () {
        customSnackbars.errorSnackbar(context,
            title: 'Please provide a valid email address.');
      },
    );
    setBusy(false);
  }

  Future<void> updateUserPassword(BuildContext context, String password) async {
    setBusy(true);
    String key = FireUserField.email;

    User? user = AuthService.liveUser;
    const hiveBox = HiveApi.userDataHiveBox;
    String currentEmail = hiveApi.getFromHive(hiveBox, key);

    bool isUserNull = user == null;

    try {
      switch (isUserNull) {
        case false:
          {
            const title = 'Password was successfully updated';
            AuthCredential credential = EmailAuthProvider.credential(
                email: currentEmail, password: password);
            await FirebaseAuth.instance.signInWithCredential(credential);
            await user!.updatePassword(password);

            customSnackbars.successSnackbar(context, title: title);
          }

          break;
        case true:
          {
            setBusy(false);
            log.w('User Is Currently Null Now');
            const title = 'something went wrong';
            customSnackbars.errorSnackbar(context, title: title);
          }
          break;
        default:
      }
    } catch (e) {
      setBusy(false);
      log.e('Update Email Error:$e');
      customSnackbars.errorSnackbar(context, title: 'something went wrong');
    }
    setBusy(false);
  }

  @override
  void dispose() {
    super.dispose();
    passwordTech.dispose();
  }
}