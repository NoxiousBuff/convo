import 'package:flutter/cupertino.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/letter_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class WriteLetterViewModel extends BaseViewModel {
  final log = getLogger('WriteLetterViewModel');

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  void updateIsEdited(bool localIsEdited) {
    _isEdited = localIsEdited;
    notifyListeners();
  }

  bool _isLetterEmpty = true;
  bool get isLetterEmpty => _isLetterEmpty;

  void updateLetterEmpty() {
    _isLetterEmpty = writeLetterTech.text.isEmpty;
    notifyListeners();
  }

  bool get isActive => !_isLetterEmpty && isEdited;

  final TextEditingController writeLetterTech = TextEditingController();

  Future<void> sendLetter(BuildContext context, FireUser fireUser) async {
    setBusy(true);
    letterService.sendLetter(fireUser, writeLetterTech.text.trim(), onComplete: () {
      writeLetterTech.clear();
      updateLetterEmpty();
      updateIsEdited(false);
    }, onError: () {
      setBusy(false);
      customSnackbars.errorSnackbar(context,
          title:
              'There was an error in sending your letters. Please try again later.');
    });
    setBusy(false);
  }
}