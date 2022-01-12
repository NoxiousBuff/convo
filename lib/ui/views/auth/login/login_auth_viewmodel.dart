import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class LoginAuthViewModel extends BaseViewModel {
  final log = getLogger('LoginAuthViewModel');

  bool emailEmpty = true;
  bool passwordEmpty = false;
  bool isPasswordShown = false;
  bool fieldNotEmpty = false;
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailTech = TextEditingController();
  final TextEditingController passwordTech = TextEditingController();
  final FocusNode focusNode = FocusNode();

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

  void areFieldNotEmpty() {
    fieldNotEmpty = emailTech.text.isNotEmpty & passwordTech.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    setBusy(true);
    focusNode.unfocus();
    await authService.logIn(
        email: email,
        password: password,
        onComplete: () {
          hiveApi.saveAndReplace(HiveApi.appSettingsBoxName,
              AppSettingKeys.hasCompletedAuthentication, true);
          pushNotificationService.createScheduledDiscoverNotifications();
          pushNotificationService.createScheduledSecurityNotifications();
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => const HomeView()),
              (route) => false);
        },
        noAccountExists: () {
          return customSnackbars.errorSnackbar(context,
              title: 'No account exist for this email.');
        },
        invalidEmail: () {
          return customSnackbars.errorSnackbar(context,
              title: 'Email Provided is invalid. Please check again.');
        },
        wrongPassword: () {
          return customSnackbars.errorSnackbar(context,
              title: 'Wrong Password');
        },
        onError: () {
          return customSnackbars.errorSnackbar(context,
              title:
                  'Something wrong happened. Please check your internet connection.');
        });
    setBusy(false);
  }

  @override
  void dispose() {
    super.dispose();
    emailTech.dispose();
    passwordTech.dispose();
  }
}
