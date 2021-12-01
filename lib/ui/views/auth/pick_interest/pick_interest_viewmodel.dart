import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'dart:convert';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:http/http.dart' as http;

final List<String> userSelectedInterests = [];

class PickInterestsViewModel extends BaseViewModel {
  final log = getLogger('PickInterestsViewModel');

  String _countryName = '';
  String get countryName => _countryName;

  GeoPoint? _geoPoint;
  GeoPoint? get geoPoint => _geoPoint;

  int _userClickedButton = 0;
  int get userClickedButton => _userClickedButton;

  void userClickedButtonChanger() {
    _userClickedButton++;
    notifyListeners();
  }

  bool _hasUserPickedTenInterests = false;
  bool get hasUserPickedTenInterests => _hasUserPickedTenInterests;

  void changeUserInterestLength() {
    _hasUserPickedTenInterests = userSelectedInterests.length >= 10;
    notifyListeners();
  }

  Future<void> createUserInFirebase(BuildContext context,
      {required String country,
      required GeoPoint location,
      required String phoneNumber,
      required String displayName,
      required String countryPhoneCode,
      required String username}) async {
    setBusy(true);
    firestoreApi
        .createUserInFirebase(
      country: country,
      location: location,
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

  Future<GeoPoint> lookUpGeopoint(
      BuildContext context) async {
    final response =
        await http.get(Uri.parse('https://api.ipregistry.co?key=tryout'));
    if (response.statusCode == 200) {
      final latitude = json.decode(response.body)['location']['latitude'];
      final longitude = json.decode(response.body)['location']['longitude'];
      final countryName =
          json.decode(response.body)['location']['country']['name'];
      _geoPoint = GeoPoint(latitude, longitude);
      _countryName = countryName;
      notifyListeners();
      return GeoPoint(latitude, longitude);
    } else {
      customSnackbars.infoSnackbar(context, title: 'Turn On Your Internet');
      throw Exception('Failed to get user country from IP address');
    }
  }
}
