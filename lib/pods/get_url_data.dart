import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final urlDataProvider = ChangeNotifierProvider((ref) => URLData());

class URLData extends ChangeNotifier {
  Map<String, dynamic>? urlPreviewData;

  void getURLData(Map<String, dynamic> urlData) {
    urlPreviewData = urlData;
    notifyListeners();
  }

  void removeURLData() {
    urlPreviewData = null;
    notifyListeners();
  }
}
