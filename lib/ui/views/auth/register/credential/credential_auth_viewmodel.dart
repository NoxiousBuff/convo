import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/register/displayname/displayname_auth_view.dart';
import 'package:stacked/stacked.dart';

class CredentialAuthViewModel extends BaseViewModel {
  final log = getLogger('CredentialAuthViewModel');
  bool emailEmpty = true;
  bool passwordEmpty = false;
  bool isPasswordShown = false;
  bool fieldNotEmpty = false;
  final databaseService = DatabaseService();
  final credentialFormKey = GlobalKey<FormState>();
  TextEditingController emailTech = TextEditingController();
  TextEditingController passwordTech = TextEditingController();

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;

  final firestoreApi = locator<FirestoreApi>();

  // String _countryName = '';
  // String get countryName => _countryName;

  // String _countryCode = '';
  // String get countryCode => _countryCode;

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

  bool isPasswordValid(String password) {
    if (password.length >= 8) {
      hasMinLength = true;
    } else {
      hasMinLength = false;
    }
    if (password.contains(RegExp(r"[a-z]"))) {
      hasLowercase = true;
    } else {
      hasLowercase = false;
    }
    if (password.contains(RegExp(r"[A-Z]"))) {
      hasUppercase = true;
    } else {
      hasUppercase = false;
    }
    if (password.contains(RegExp(r"[0-9]"))) {
      hasDigits = true;
    } else {
      hasDigits = false;
    }
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      hasSpecialCharacters = true;
    } else {
      hasSpecialCharacters = false;
    }
    notifyListeners();
    final value = hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
    return value;
  }

  void areFieldNotEmpty() {
    fieldNotEmpty = emailTech.text.isNotEmpty & passwordTech.text.isNotEmpty;
    notifyListeners();
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

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setBusy(true);
    hiveApi.saveAndReplace(
        HiveApi.appSettingsBoxName, FireUserField.email, emailTech.text);
    await authService.signUp(
        email: email,
        password: password,
        onComplete: () {
          return customSnackbars.infoSnackbar(context,
              title: 'You have been sent a verification email.');
        },
        accountExists: () {
          return customSnackbars.errorSnackbar(context,
              title: 'This Email is already in use. Please login');
        },
        weakPassword: () {
          return customSnackbars.errorSnackbar(context,
              title: 'Passsword is weak. Please make a strong password.');
        },
        randomError: () {
          return customSnackbars.errorSnackbar(context,
              title:
                  'Something wrong happened. Please check your internet connection.');
        });

    if (FirebaseAuth.instance.currentUser != null) {
      await createUserInFirebase(context);
    } else {
      log.e('Firebase user is null');
    }
    setBusy(false);
    if (FirebaseAuth.instance.currentUser != null) {
      navService.cupertinoPageRoute(context, const DisplayNameAuthView());
    }
  }

  Future<void> createUserInFirebase(BuildContext context) async {
    firestoreApi
        .createUserInFirebase(
      user: FirebaseAuth.instance.currentUser!,
    )
        .then((value) async {
      await databaseService.addUserData(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  // Future<void> lookUpGeopoint(BuildContext context) async {
  //   final response =
  //       await http.get(Uri.parse('https://api.ipregistry.co?key=tryout'));
  //   if (response.statusCode == 200) {
  //     _countryName =
  //         jsonDecode(response.body)['location']['country']['name'].toString();
  //     _countryCode = jsonDecode(response.body)['location']['country']
  //             ['calling_code']
  //         .toString();
  //     notifyListeners();
  //   } else {
  //     customSnackbars.infoSnackbar(context, title: 'Turn On Your Internet');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    emailTech.dispose();
    passwordTech.dispose();
  }
}
