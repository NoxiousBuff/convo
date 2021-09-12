import 'package:flutter/cupertino.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  bool emailEmpty = true;
  bool passwordEmpty = true;
  bool isPasswordShown = false;

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

  void logIn(
      {required String email,
      required String password,
      required Function onComplete}) async {
    setBusy(true);
    await _authService.logIn(
        email: email, password: password, onComplete: onComplete);
    setBusy(false);
  }
}