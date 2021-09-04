import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EmailRegisterViewModel extends BaseViewModel {
  final emailFormKey = GlobalKey<FormState>();
  bool emailEmpty = true;
  TextEditingController emailTech = TextEditingController();

  void updateEmailEmpty() {
    emailEmpty = emailTech.text.isEmpty;
    notifyListeners();
  }
}