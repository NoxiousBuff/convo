import 'package:flutter/cupertino.dart';



class VerifyEmailStatus extends ChangeNotifier {
  bool isBannerVisible = true;

  void updateBannerVisibility(bool localIsBannerVisible) {
    isBannerVisible = localIsBannerVisible;
    notifyListeners();
  }
}