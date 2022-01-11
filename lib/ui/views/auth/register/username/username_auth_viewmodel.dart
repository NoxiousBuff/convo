import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/extensions/query.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/pick_interest/pick_interest_view.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class UserNameAuthViewModel extends BaseViewModel {
  final log = getLogger('UserNameAuthViewModel');

  final userNameFormKey = GlobalKey<FormState>();

  final TextEditingController userNameTech = TextEditingController();

  UserNameExists _doesExists = UserNameExists.didNotChecked;
  UserNameExists get doesExists => _doesExists;

  final FocusNode focusNode = FocusNode();

  final firestoreApi = locator<FirestoreApi>();

  bool _isUserNameEmpty = true;
  bool get isUserNameEmpty => _isUserNameEmpty;

  void updateUserNameEmpty() {
    _isUserNameEmpty = userNameTech.text.length < 3;
    notifyListeners();
  }

  void findUsernameExistOrNot(String value) async {
    if(value.length > 3) {
      _doesExists = UserNameExists.checking;
    notifyListeners();
    final snapshotData = await FirebaseFirestore.instance.collection(subsFirestoreKey).where(FireUserField.username, isEqualTo: value).getSavy();
    final doc = snapshotData.docs;
    if(doc.isNotEmpty) {
      _doesExists = UserNameExists.no;
    } else {
      _doesExists = UserNameExists.yes;
    }
    log.wtf(doc.toString());
    log.wtf(_doesExists);
    notifyListeners();
    } else {
      _doesExists = UserNameExists.tooShort;
      notifyListeners();
    }
  }

  Future<void> updateUserDisplayName(BuildContext context) async {
    setBusy(true);
    final liveUser = AuthService.liveUser;
    if(liveUser != null) {
      await firestoreApi.changeUserName(userNameTech.text.trim()).then((value) {
        hiveApi.updateUserData(FireUserField.username, userNameTech.text.trim());
        setBusy(false);
        navService.materialPageRoute(context, const PickInterestsView());
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