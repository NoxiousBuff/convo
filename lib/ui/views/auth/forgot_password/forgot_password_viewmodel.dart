import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/login/login_auth_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ForgotPasswordAuthViewModel extends BaseViewModel {
  final log = getLogger('ForgotPasswordAuthViewModel');

  final forgotPasswordFormKey = GlobalKey<FormState>();

  bool _emailNotEmpty = false;
  bool get emailNotEmpty => _emailNotEmpty;

  final TextEditingController _emailTech = TextEditingController();
  TextEditingController get emailTech => _emailTech;

  final AuthService _authService = AuthService();

  void updateEmailEmpty() {
    _emailNotEmpty = emailTech.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    setBusy(true);
    await _authService.forgotPassword(email,
        onComplete: () {
          customSnackbars.successSnackbar(context, title: 'You have been sent a password reset email successfully. Check you inbox.');
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> const LoginAuthView()));
        },
        onError: () {
          customSnackbars.errorSnackbar(context, title: 'Something went wrong. Please check your internet connection.');
        },
        noAccountExists: () {
          customSnackbars.errorSnackbar(context, title: 'No user found with this email. Please check you email again.');
        },
        invalidEmailAddress: () {
          customSnackbars.errorSnackbar(context, title: 'Please provide a valid email address.');
        },);
    setBusy(false);
  }

  @override
  void dispose() {
    super.dispose();
    emailTech.dispose();
  }
}
