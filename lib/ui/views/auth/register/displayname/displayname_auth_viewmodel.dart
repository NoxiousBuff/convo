import 'package:flutter/material.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/register/username/username_auth_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DisplayNameAuthViewModel extends BaseViewModel {
  final log = getLogger('UsernameAuthModel');
  final String countryCode;
  final String phoneNumber;

  DisplayNameAuthViewModel(this.countryCode, this.phoneNumber);

  bool _isDisplayNameEmpty = true;
  bool get isDisplayNameEmpty => _isDisplayNameEmpty;

  final TextEditingController displayNameTech = TextEditingController();

  void updateDisplayNameEmpty() {
    _isDisplayNameEmpty = displayNameTech.text.isEmpty;
    notifyListeners();
  }

  final displayNameFormKey = GlobalKey<FormState>();

  Future<void> updateDisplayName(BuildContext context) async {
    setBusy(true);
    final liveUser = AuthService.liveUser;
    if (liveUser != null) {
      liveUser.updateDisplayName(displayNameTech.text);
      setBusy(false);
      navService.materialPageRoute(context, UserNameAuthView(phoneNumber: phoneNumber, displayName: displayNameTech.text, countryCode: countryCode));
    } else {
      customSnackbars.errorSnackbar(context, title: 'Something went wrong !!!');
    }
  }
}
