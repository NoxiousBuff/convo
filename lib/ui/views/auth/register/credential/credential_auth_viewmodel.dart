import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/register/phone/phone_auth_view.dart';
import 'package:stacked/stacked.dart';

class CredentialAuthViewModel extends BaseViewModel {
  final log = getLogger('CredentialAuthViewModel');
  bool emailEmpty = true;
  bool passwordEmpty = false;
  bool isPasswordShown = false;
  bool fieldNotEmpty = false;
  final credentialFormKey = GlobalKey<FormState>();
  TextEditingController emailTech = TextEditingController();
  TextEditingController passwordTech = TextEditingController();

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;

  void updateEmailEmpty() {
    emailEmpty = emailTech.text.isEmpty;
    notifyListeners();
  }

  void updatePasswordEmpty() {
    passwordEmpty = passwordTech.text.isEmpty;
    notifyListeners();
  }

  void updatePasswordShown() {
    isPasswordShown = !isPasswordShown;
    notifyListeners();
  }

  bool isPasswordValid(String password) {
    if (password.length >= 8) {
      hasMinLength = true;
    } else {
      hasMinLength = false;
    }
    if (password.contains(RegExp(r"[a-z]"))) {
      hasLowercase = true;
    } else {
      hasLowercase = false;
    }
    if (password.contains(RegExp(r"[A-Z]"))) {
      hasUppercase = true;
    } else {
      hasUppercase = false;
    }
    if (password.contains(RegExp(r"[0-9]"))) {
      hasDigits = true;
    } else {
      hasDigits = false;
    }
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      hasSpecialCharacters = true;
    } else {
      hasSpecialCharacters = false;
    }
    notifyListeners();
    final value = hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
    log.wtf('This is the value of ${value.toString()}');
    return value;
  }

  void areFieldNotEmpty() {
    fieldNotEmpty = emailTech.text.isNotEmpty & passwordTech.text.isNotEmpty;
    notifyListeners();
  }

  Future<bool> checkIsEmailExists(String email) async {
    setBusy(true);
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (list.isEmpty) {
      setBusy(false);
      return false;
    } else {
      setBusy(false);
      return true;
    }
  }

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setBusy(true);
    await authService.signUp(
        email: email,
        password: password,
        onComplete: () {
          return customSnackbars.infoSnackbar(context,
              title: 'You have been sent a verification email.');
        },
        accountExists: () {
          return customSnackbars.errorSnackbar(context,
              title: 'This Email is already in use. Please login');
        },
        weakPassword: () {
          return customSnackbars.errorSnackbar(context,
              title: 'Passsword is weak. Please make a strong password.');
        },
        randomError: () {
          return customSnackbars.errorSnackbar(context,
              title:
                  'Something wrong happened. Please check your internet connection.');
        });
    setBusy(false);
    if(FirebaseAuth.instance.currentUser != null) {
      navService.cupertinoPageRoute(context, const PhoneAuthView());
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailTech.dispose();
    passwordTech.dispose();
  }
}
