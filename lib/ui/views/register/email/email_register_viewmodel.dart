import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EmailRegisterViewModel extends BaseViewModel {
  final emailFormKey = GlobalKey<FormState>();
  bool emailEmpty = true;
  bool passwordEmpty = false;
  bool isPasswordShown = false;
  TextEditingController emailTech = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void updateEmailEmpty() {
    emailEmpty = emailTech.text.isEmpty;
    notifyListeners();
  }

 void updatePasswordEmpty() {
    emailEmpty = passwordController.text.isEmpty;
    notifyListeners();
  }

  void updatePasswordShown() {
    isPasswordShown = !isPasswordShown;
    notifyListeners();
  }
}
