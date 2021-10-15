import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class UsernameRegisterViewModel extends BaseViewModel {
  final usernameFormKey = GlobalKey<FormState>();
  static final AuthService _authService = AuthService();
  static final FirestoreApi _firestoreApi = FirestoreApi();

  final TextEditingController _firstNameController = TextEditingController();
  TextEditingController get firstNameTech => _firstNameController;

  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController get lastNameTech => _lastNameController;

  bool firstNameEmpty = true;
  bool lastNameEmpty = true;

  void updateFirstNameEmpty() {
    firstNameEmpty = firstNameTech.text.isEmpty;
    notifyListeners();
  }

  void updateSecondNameEmpty() {
    lastNameEmpty = lastNameTech.text.isEmpty;
    notifyListeners();
  }

  void updateUserDisplayName(String value,
      {Function? onError, Function? onComplete}) {
    _firestoreApi.changeUserDisplayName(value);
    _authService.changeUserDisplayName(value, onError: onError);
    if(onComplete != null) onComplete();
  }
}