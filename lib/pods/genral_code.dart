import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final codeProvider = ChangeNotifierProvider((ref) => VerificationCode());

class VerificationCode extends ChangeNotifier {
  String? optCode;
  PhoneAuthCredential? phoneAuthCredential;

  void getCode(String code) {
    optCode = code;
    notifyListeners();
  }

  void getPhoneCredentials(PhoneAuthCredential credentials) {
    phoneAuthCredential = credentials;
    notifyListeners();
  }
}
