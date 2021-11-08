import 'package:hint/app/app.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/recent_chats/recent_chats.dart';
import 'package:hint/ui/views/register/user_interests/user_interest.dart';

class InterestsViewModel extends BaseViewModel {
  final log = getLogger('InterestViewModel');
  final List<String> _selectedInterests = [];
  List<String> get selectedInterests => _selectedInterests;

  int length() => _selectedInterests.length;

  void addInterest(String interest) => _selectedInterests.add(interest);

  Future<void> createUserInDataBase(
    BuildContext context, {
    required String email,
    required String username,
    required User? createdUser,
    required String phoneNumber,
    required String countryPhoneCode,
    required List<String> selectedInterests,
  }) async {
    setBusy(true);
    await createdUser!.reload();
    await AppWriteApi.instance.createLiveChatUser(createdUser.uid);
    await firestoreApi
        .createUserInFirebase(
            user: createdUser,
            username: username,
            phoneNumber: phoneNumber,
            interests: selectedInterests,
            countryPhoneCode: countryPhoneCode)
        .then((value) {
      log.wtf('user created in firestore');
      loggedIn = true;
      notifyListeners();
    });
    Navigator.push(
      context,
      cupertinoTransition(
        enterTo: const RecentChats(),
        exitFrom: InterestsView(
          email: email,
          username: username,
          phoneNumber: phoneNumber,
          createdUser: createdUser,
          countryPhoneCode: countryPhoneCode,
        ),
      ),
    );
    setBusy(false);
  }
}
