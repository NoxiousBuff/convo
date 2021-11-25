import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

final List<String> userSelectedInterests = [];

class PickInterestsViewModel extends BaseViewModel {
  final log = getLogger('PickInterestsViewModel');

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
      required String countryPhoneCode}) async {
    setBusy(true);
    firestoreApi
        .createUserInFirebase(
            country: country,
            location: location,
            username: displayName,
            phoneNumber: phoneNumber,
            user: AuthService.liveUser!,
            countryPhoneCode: countryPhoneCode,
            interests: userSelectedInterests)
        .then((value) async {
      await databaseService.addUserData(AuthService.liveUser!.uid);
      setBusy(false);
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const ChatListView()),
          (route) => false);
    });
  }

  String getFirstName() {
    String displayName = AuthService.liveUser!.displayName!;
    List<String> wordList = displayName.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0];
    } else {
      return ' ';
    }
  }
}
