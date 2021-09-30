import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  int? value;

  void currentIndex(int? i) {
    value = i;
    notifyListeners();
  }

  List<String> optionName = [
    'For 15 Minutes',
    'For 1 Hour',
    'For 8 Hours',
    'For 24 Hours',
    'Until I turn it back on'
  ];
}
