import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadListenerProvider = ChangeNotifierProvider((ref) => UploadListener());

class UploadListener extends  ChangeNotifier {
  bool isUploading = false;

  void setUploading(bool localIsUploading) {
    isUploading = localIsUploading;
    notifyListeners();
  }
}