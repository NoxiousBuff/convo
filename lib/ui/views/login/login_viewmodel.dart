import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  bool emailEmpty = true;
  bool passwordEmpty = true;
  bool isPasswordShown = false;
  final log = getLogger('LoginVIewModel');
  TextEditingController emailTech = TextEditingController();
  TextEditingController passwordTech = TextEditingController();

  final AuthService _authService = AuthService();

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

  void logIn({
    required String email,
    required String password,
    required Function onComplete,
    required BuildContext context,
  }) async {
    try {
      setBusy(true);

      await _authService.logIn(
          email: email, password: password, onComplete: onComplete);
      await AuthService.liveUser!.reload();
      setBusy(false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: systemRed,
          content: Text(
            'Login Failed',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: systemBackground),
          ),
        ),
      );
    }
  }
}
