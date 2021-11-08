import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/views/register/username/username_register_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    setBusy(true);
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      log.e(e);
    });
    final user = userCredential.user;
    if (user != null && !user.emailVerified) await user.sendEmailVerification();

    setBusy(false);
    return userCredential.user;
  }

  Future<bool> checkIsEmailExists(String email) async {
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> signUpInFirebase(
      String email, String password, BuildContext context) async {
    try {
      setBusy(true);
      bool emailExists = await checkIsEmailExists(email);
      if (!emailExists) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsernameRegisterView(
                email: email,
                createdUser: user,
                password: password,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: systemRed,
            content: Text(
              'This email is already in use choose another',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: systemRed,
          content: Text(
            'Unable to sign up',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: systemBackground),
          ),
        ),
      );
    }
    setBusy(false);
  }
}
