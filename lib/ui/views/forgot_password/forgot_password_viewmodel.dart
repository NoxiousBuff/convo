import 'package:hint/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  bool emailEmpty = true;

  final TextEditingController _emailTech = TextEditingController();
  TextEditingController get emailTech => _emailTech;

  final AuthService _authService = AuthService();

  void updateEmailEmpty() {
    emailEmpty = emailTech.text.isEmpty;
    notifyListeners();
  }

  Future<void> forgotPassword(
      String email, {Function? onComplete, Function? onError}) async {
    setBusy(true);
    await _authService.forgotPassword(email, onComplete : onComplete, onError : onError);
    setBusy(false);
  }
}