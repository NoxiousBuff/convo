import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final codeProvider = ChangeNotifierProvider((ref) => VerificationCode());
class VerificationCode extends ChangeNotifier {
  String optCode = '';


  void getCode(String code){
    optCode = code;
    notifyListeners();
  }
}
