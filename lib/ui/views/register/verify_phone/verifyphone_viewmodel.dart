import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class VerifyPhone extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();
}
