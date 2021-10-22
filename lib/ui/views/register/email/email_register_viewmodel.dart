import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class EmailRegisterViewModel extends BaseViewModel {
  final log = getLogger('EmailRegisterViewModel');
  bool emailEmpty = true;
  bool passwordEmpty = false;
  bool isPasswordShown = false;
  final emailFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<User?> singUp(String email, String password) async {
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      log.e(e);
    });
    final user = userCredential.user;
    if (user != null && user.emailVerified) {
      await user.updatePhotoURL(AuthService.kDefaultPhotoUrl);
      user.sendEmailVerification().catchError((e) {
        log.e('sendVerificationEmail:$e');
      }).then((value) => log.wtf('verification email is sended successfully'));
    }
    return userCredential.user;
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
}
