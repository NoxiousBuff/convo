import 'package:flutter/cupertino.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class DuleViewModel extends StreamViewModel {

  DuleViewModel(this.fireUser);

  final FireUser fireUser;
  final log = getLogger('DuleViewModel');

  final TextEditingController duleTech = TextEditingController();

  final TextEditingController otherTech = TextEditingController();

  String _wordLengthLeft = '160';
  String get wordLengthLeft => _wordLengthLeft;

  int _duleFlexFactor = 1;
  int get duleFlexFactor => _duleFlexFactor;

  int _otherFlexFactor = 1;
  int get otherFlexFactor => _otherFlexFactor;

  
  bool _isDuleEmpty = true;
  bool get isDuleEmpty => _isDuleEmpty;

  final FocusNode duleFocusNode = FocusNode();

  void updateDuleFocus() {
    duleFocusNode.hasFocus ? duleFocusNode.unfocus() : duleFocusNode.requestFocus();
    notifyListeners();
  }

  void onTextChanged(String value) {}

  void updatTextFieldWidth() {
    final duleLength = duleTech.text.length;
    final otherLength = otherTech.text.length;
    if(otherLength < 30) {
      if(duleLength < 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 2;
      } else {
        _duleFlexFactor = 6;
        _otherFlexFactor = 2;
      }
    } else if (otherLength > 30) {
      if(duleLength < 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 6;
      } else if (duleLength > 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 2;
      }
    }
    _isDuleEmpty = duleTech.text.isEmpty;
    notifyListeners();
  }

  void clearMessage() {
    if(!isDuleEmpty) {
      duleTech.clear();
      _isDuleEmpty = true;
      updatTextFieldWidth();
      updateWordLengthLeft(duleTech.text);
    }
  }

  void updateOtherField(String value) {
    otherTech.text = value;
  }

  void updateWordLengthLeft(String value) {
    final lengthLeft = 160 - value.length;
    _wordLengthLeft = lengthLeft.toString();
    notifyListeners();
  } 

  @override
  void dispose() {
    super.dispose();
    duleFocusNode.dispose();
    duleTech.dispose();
    otherTech.dispose();
  }

  @override
  ///TODO: change this to [fireuser.id]
  Stream get stream => databaseService.getUserData(fireUser.id);

}