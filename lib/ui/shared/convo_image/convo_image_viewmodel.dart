import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

class ConvoImageViewModel extends BaseViewModel {
  bool _hiveContainsPath = false;
  bool get hiveContainPath => _hiveContainsPath;

  void hivePathCheckerValue(String hiveBoxName, String messageUid) {
    _hiveContainsPath = Hive.box(hiveBoxName).containsKey(messageUid);
  }
}
