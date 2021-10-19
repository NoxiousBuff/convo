import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsernameRegisterViewModel extends BaseViewModel {
  final log = getLogger('UsernameRegisterViewModel');
  final FocusNode focusNode = FocusNode();
  final key = GlobalKey<FormState>();

  static final _auth = FirebaseAuth.instance;
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

  Future<User?> singUp(String email, String password) async {
    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      log.e(e);
    });
    final user = userCredential.user;
    if (user != null && user.emailVerified) {
      user.sendEmailVerification().catchError((e) {
        log.e('sendVerificationEmail:$e');
      }).then((value) => log.wtf('verification email is sended successfully'));
    }
    return userCredential.user;
  }
}
