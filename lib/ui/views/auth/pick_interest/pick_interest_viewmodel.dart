import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/choose_profile_photo/choose_profile_photo_view.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class PickInterestsViewModel extends BaseViewModel {
  final log = getLogger('PickInterestsViewModel');

  bool _hasUserPickedTenInterests = false;
  bool get hasUserPickedTenInterests => _hasUserPickedTenInterests;

  final List<String> userSelectedInterests = [];

  void changeInterestLength() {
    _hasUserPickedTenInterests = userSelectedInterests.length >= 10;
    notifyListeners();
  }

  final firestoreApi = locator<FirestoreApi>();

  Future<void> updateUserSelectedInterests(BuildContext context) async {
    setBusy(true);
    final liveUser = AuthService.liveUser;
    if (liveUser != null) {
      await firestoreApi
          .updateUser(
              uid: AuthService.liveUser!.uid,
              value: userSelectedInterests,
              propertyName: FireUserField.interests)
          .then((value) {
        hiveApi.updateUserData(FireUserField.interests, userSelectedInterests);
        hiveApi.saveAndReplace(HiveApi.appSettingsBoxName,
            AppSettingKeys.hasCompletedAuthentication, true);
        pushNotificationService.createScheduledDiscoverNotifications();
        pushNotificationService.createScheduledSecurityNotifications();
        setBusy(false);
        log.wtf('User Selected Interest : $userSelectedInterests');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ChooseProfilePhotoView()),
            (route) => false);
      }).onError((error, stackTrace) {
        setBusy(false);
        log.e(error);
        return customSnackbars.errorSnackbar(context,
            title: 'Check your internet connection');
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeView()),
          (route) => false);
    }
  }
}
