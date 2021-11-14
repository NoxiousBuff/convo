import 'package:flutter/material.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/pick_interest/pick_interest_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class UsernameAuthViewModel extends BaseViewModel {
  final log = getLogger('UsernameAuthModel');
  final String countryCode;
  final String phoneNumber;

  UsernameAuthViewModel(this.countryCode, this.phoneNumber);

  bool isDisplayNameEmpty = true;

  final TextEditingController displayNameTech = TextEditingController();

  void updateDisplayNameEmpty() {
    isDisplayNameEmpty = displayNameTech.text.isEmpty;
    notifyListeners();
  }

  final displayNameFormKey = GlobalKey<FormState>();

  Future<void> updateDisplayName(BuildContext context) async {
    setBusy(true);
    final liveUser = AuthService.liveUser;
    if (liveUser != null) {
      liveUser.updateDisplayName(displayNameTech.text);
      setBusy(false);
      navService.materialPageRoute(context, PickInterestsView(phoneNumber: phoneNumber, displayName: displayNameTech.text, countryCode: countryCode));
    } else {
      customSnackbars.errorSnackbar(context, title: 'Something went wrong !!!');
      //TODO: write code to terminate the whole thing. and start over.
    }
  }
}
