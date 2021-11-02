import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_view.dart';
import 'package:hint/ui/views/register/username/username_register_view.dart';

class UsernameRegisterViewModel extends BaseViewModel {
  final log = getLogger('UsernameRegisterViewModel');
  final FocusNode focusNode = FocusNode();
  final key = GlobalKey<FormState>();

  static final AuthService _authService = AuthService();
  static final FirestoreApi _firestoreApi = FirestoreApi();

  final TextEditingController _controller = TextEditingController();
  TextEditingController get usernameTech => _controller;

  bool usernameEmpty = true;

  void updateUsernameEmpty() {
    usernameEmpty = usernameTech.text.isEmpty;
    notifyListeners();
  }

  Future<void> createAppWriteUser(
    BuildContext context, {
    required String username,
    required String email,
    required String password,
    required User? fireUser,
  }) async {
    setBusy(true);
    bool isSignedUp = await appWriteSignUp(
      username: username,
      email: email,
      password: password,
    );
    if (isSignedUp) {
      Navigator.push(
        context,
        cupertinoTransition(
          enterTo: PhoneAuthView(
            email: email,
            createdUser: fireUser,
            username: username,
          ),
          exitFrom: UsernameRegisterView(
            email: email,
            fireUser: fireUser,
            password: password,
          ),
        ),
      );
    } else {
      getLogger('UsernameRegisterView').wtf('appwrite sign up failed');
    }
    setBusy(false);
  }

  void updateUserDisplayName(String value,
      {Function? onError, Function? onComplete}) {
    _firestoreApi.changeUserDisplayName(value);
    _authService.changeUserDisplayName(value, onError: onError);
    if (onComplete != null) onComplete();
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

  Future<bool> appWriteSignUp({
    required String email,
    required String password,
    required String username,
  }) async {
    setBusy(true);
    bool isSignedUp = await AppWriteApi.instance.signup(
      email: email,
      name: username,
      password: password,
    );
    setBusy(false);
    if (isSignedUp) {
      return true;
    } else {
      return false;
    }
  }
}
