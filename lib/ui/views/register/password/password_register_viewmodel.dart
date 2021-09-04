import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class PasswordRegisterViewModel extends BaseViewModel {
  final passwordFormKey = GlobalKey<FormState>();
  bool passwordEmpty = true;
  TextEditingController passwordTech = TextEditingController();
  late String _email;
  String get email => _email;
  bool isPasswordShown = false;
  static AuthService _authService = AuthService();

  void updateUserEmail(String email) {
    _email = email;
    getLogger('PasswordRegisterViewModel').i('Email received: $email');
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

  void signUpUser() async {
    setBusy(true);
    getLogger('PassswordRegisterViewModel').d(isBusy);
    await _authService.signUp(
        email: _email, password: passwordTech.text, onComplete: () {});
    setBusy(false);
    getLogger('PassswordRegisterViewModel').d(isBusy);
  }
}