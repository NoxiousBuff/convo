import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/register/username/username_auth_view.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DisplayNameAuthViewModel extends BaseViewModel {
  final log = getLogger('UsernameAuthModel');
  // final String countryCode;
  // final String phoneNumber;

  bool _isDisplayNameEmpty = true;
  bool get isDisplayNameEmpty => _isDisplayNameEmpty;

  final firestoreApi = locator<FirestoreApi>();

  final TextEditingController displayNameTech = TextEditingController();

  void updateDisplayNameEmpty() {
    _isDisplayNameEmpty = displayNameTech.text.isEmpty;
    notifyListeners();
  }

  final displayNameFormKey = GlobalKey<FormState>();

  Future<void> updateDisplayName(BuildContext context) async {
    setBusy(true);
    final liveUser = AuthService.liveUser;
    if(liveUser != null) {
      liveUser.updateDisplayName(displayNameTech.text);
      await firestoreApi.changeUserDisplayName(displayNameTech.text.trim()).then((value) {
        hiveApi.updateUserData(FireUserField.displayName, displayNameTech.text.trim());
        setBusy(false);
        navService.materialPageRoute(context, const UserNameAuthView());
      }).onError((error, stackTrace) {
        setBusy(false);
        return customSnackbars.errorSnackbar(context, title: 'Check your internet connection');
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeView()),
          (route) => false);
    }
  }
}
