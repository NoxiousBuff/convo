import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageControllerPod = ChangeNotifierProvider((ref) => PageControllerPod());

class PageControllerPod extends ChangeNotifier{
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void currentIndexChanger(int localCurrentIndex) {
    _currentIndex = localCurrentIndex;
    notifyListeners();
  }
}