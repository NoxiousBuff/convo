import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
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

  void logIn(
      {required String email,
      required String password,
      required Function onComplete}) async {
    setBusy(true);
    await AppWriteApi.instance.login(email: email, password: password);
    await _authService.logIn(
        email: email, password: password, onComplete: onComplete);
    await AuthService.liveUser!.reload().catchError((e) {
      log.e('Reload LiveUser:$e');
    });
    setBusy(false);
  }
}
