import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void updateUserDisplayName(String value,
      {Function? onError, Function? onComplete}) {
    _firestoreApi.changeUserDisplayName(value);
    _authService.changeUserDisplayName(value, onError: onError);
    if (onComplete != null) onComplete();
  }

  Future<bool> checkIsUsernameExists(username) async {
    return await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .where(FireUserField.username, isEqualTo: username)
        .get()
        .then((value) => value.size > 0 ? true : false)
        .catchError((e) {
      log.e('checkIsUsernameExists Error:$e');
    });
  }
}
