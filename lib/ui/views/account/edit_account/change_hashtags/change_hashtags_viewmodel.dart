import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeHashtagsViewModel extends BaseViewModel {
  final log = getLogger('ChangeHashtagsViewModel');

  final TextEditingController hashTagTech = TextEditingController();

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  void updateIsEdited(bool localIsEdited) {
    _isEdited = localIsEdited;
    notifyListeners();
  }

  bool get isActive => !isHashTagEmpty && _isEdited;

  bool _isHashTagEmpty = true;
  bool get isHashTagEmpty => _isHashTagEmpty;

  void updateHashTagEmpty() {
    _isHashTagEmpty = hashTagTech.text.isEmpty;
    notifyListeners();
  }

  final List<dynamic> _updatedList = hiveApi.getUserData(FireUserField.hashTags);
  List<dynamic> get updatedList => _updatedList;

  void addToList(String value) {
    if(updatedList.length < 3) {
      _updatedList.add(value);
      hashTagTech.clear();
      updateIsEdited(false);
      notifyListeners();
    }
  }

  void removeFromList(String value) {
      updatedList.remove(value);
      notifyListeners();
  }
final firestoreApi = locator<FirestoreApi>();
  Future<void> updateUserProperty(
      BuildContext context, String propertyName, dynamic value) async {
    setBusy(true);
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: value,
      propertyName: propertyName,
    )
        .then((instance) {
      hiveApi.updateUserData(propertyName, value);
    });
    setBusy(false);
  }
}
