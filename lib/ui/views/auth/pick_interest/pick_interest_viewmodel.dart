import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:http/http.dart' as http;

final List<String> userSelectedInterests = [];

class PickInterestsViewModel extends BaseViewModel {
  final log = getLogger('PickInterestsViewModel');

  String _countryName = '';
  String get countryName => _countryName;

  
  int _userClickedButton = 0;
  int get userClickedButton => _userClickedButton;

  void userClickedButtonChanger() {
    _userClickedButton++;
    notifyListeners();
  }

  bool _hasUserPickedTenInterests = false;
  bool get hasUserPickedTenInterests => _hasUserPickedTenInterests;

  void changeInterestLength() {
    _hasUserPickedTenInterests = userSelectedInterests.length >= 10;
    notifyListeners();
  }

  final firestoreApi = locator<FirestoreApi>();

  Future<void> createUserInFirebase(BuildContext context,
      {required String country,
      required String phoneNumber,
      required String displayName,
      required String countryPhoneCode,
      required String username}) async {
    setBusy(true);
    firestoreApi
        .createUserInFirebase(
      country: country,
      displayName: displayName,
      phoneNumber: phoneNumber,
      user: AuthService.liveUser!,
      countryPhoneCode: countryPhoneCode,
      interests: userSelectedInterests,
      username: username,
    )
        .then((value) async {
      await databaseService.addUserData(AuthService.liveUser!.uid);
      userSelectedInterests.clear;
      setBusy(false);
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeView()),
          (route) => false);
    });
  }

  Future<void> lookUpGeopoint(BuildContext context) async {
    final response =
        await http.get(Uri.parse('https://api.ipregistry.co?key=tryout'));
    if (response.statusCode == 200) {
      _countryName = countryName;
      notifyListeners();
    } else {
      customSnackbars.infoSnackbar(context, title: 'Turn On Your Internet');
    }
  }
}
