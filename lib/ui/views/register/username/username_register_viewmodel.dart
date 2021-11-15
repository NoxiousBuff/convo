import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_view.dart';
import 'package:hint/ui/views/register/username/username_register_view.dart';

class UsernameRegisterViewModel extends BaseViewModel {
  final log = getLogger('UsernameRegisterViewModel');
  final FocusNode focusNode = FocusNode();
  final key = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  TextEditingController get usernameTech => _controller;

  bool usernameEmpty = true;

  void updateUsernameEmpty() {
    usernameEmpty = usernameTech.text.isEmpty;
    notifyListeners();
  }

  Future<void> usernameChecker(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
    required User? createdUser,
  }) async {
    try {
      setBusy(true);

      bool isUsernameExists = await checkIsUsernameExists(username);
      if (!isUsernameExists) {
        // await AppWriteApi.instance
        //     .signup(name: username, email: email, password: password);
        //await AppWriteApi.instance.logIn(email: email, password: password);

        Navigator.push(
          context,
          cupertinoTransition(
            enterTo: PhoneAuthView(
              email: email,
              username: username,
              createdUser: createdUser,
            ),
            exitFrom: UsernameRegisterView(
              email: email,
              password: password,
              createdUser: createdUser,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: systemRed,
            content: Text(
              'This username is not available',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      }
      setBusy(false);
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: systemRed,
          content: Text(
            'selecting username is failed',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: systemBackground),
          ),
        ),
      );
    }
  }

  Future<bool> checkIsUsernameExists(username) async {
    return await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .where(UserField.username, isEqualTo: username)
        .get()
        .then((value) => value.size > 0 ? true : false)
        .catchError((e) {
      log.e('checkIsUsernameExists Error:$e');
    });
  }
}
