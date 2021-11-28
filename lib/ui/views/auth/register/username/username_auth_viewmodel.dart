import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class UserNameAuthViewModel extends BaseViewModel {
  final log = getLogger('UserNameAuthViewModel');

  final userNameFormKey = GlobalKey<FormState>();

  final TextEditingController userNameTech = TextEditingController();

  UserNameExists _doesExists = UserNameExists.didNotChecked;
  UserNameExists get doesExists => _doesExists;

  final FocusNode focusNode = FocusNode();

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
    final snapshotData = await FirebaseFirestore.instance.collection(subsFirestoreKey).where(FireUserField.username, isEqualTo: value).get();
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

}