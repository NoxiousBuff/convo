import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class PixaBayViewModel extends BaseViewModel {
  final NativeAdController _adController = NativeAdController();

  final List<String?> _selectedImages = [];
  List<String?> get selectedImages => _selectedImages;

  String? _connection;
  String? get connection => _connection;

  final Connectivity _connectivity = Connectivity();
  Connectivity get connectivity => _connectivity;

  final String _apiKey = '14195414-4a5248216a1279549bea84f21';
  String get apiKey => _apiKey;

  PixabayResponse? images;

  final PixabayPicker _picker = PixabayPicker(
      apiKey: '14195414-4a5248216a1279549bea84f21', language: "hu");

  void adController() {
    _adController.load(keywords: ['valorant', 'games', 'fortnite']);
    _adController.onEvent.listen((event) {
      if (event.keys.first == NativeAdEvent.loaded) {
        notifyListeners();
      }
    });
  }

  bool contain(String? image) {
    final contains = _selectedImages.contains(image);
    return contains;
  }

  Future<PixabayResponse?> imagesCategory({String? category}) async {
    final res = await _picker.api!
        .requestImages(resultsPerPage: 200, category: category);
    images = res;
    notifyListeners();
  }

  Future<PixabayResponse?> getImages(String keyWord) async {
    final res = await _picker.api!
        .requestImagesWithKeyword(keyword: keyWord, resultsPerPage: 200);
    images = res;

    notifyListeners();
  }

  // Add Images To selected pixabay image
  void addImage(String? value) {
    _selectedImages.add(value);
    notifyListeners();
  }

  // Remove Images To selected pixabay image
  void removeImage(String? value) {
    _selectedImages.remove(value);
    notifyListeners();
  }
}
