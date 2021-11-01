

import 'package:flutter/cupertino.dart';

class TextEditorViewModel extends ChangeNotifier {


   int index = 0;

  void increseIndex() {
    index++;
    notifyListeners();
  }

  void resetIndex() {
    index = 0;
    notifyListeners();
  }
}