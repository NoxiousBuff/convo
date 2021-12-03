import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeHashtagsViewModel extends BaseViewModel {
  final log = getLogger('ChangeHashtagsViewModel');

  final TextEditingController firstTech = TextEditingController();
  final TextEditingController secondTech = TextEditingController();
  final TextEditingController thirdTech = TextEditingController();

}