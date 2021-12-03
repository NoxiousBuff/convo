import 'dart:math';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:stacked/stacked.dart';

class ExploreViewModel extends BaseViewModel {
  final log = getLogger('ExploreViewModel');

  List<PixabayMedia>? images = [];

  PixabayPicker picker = PixabayPicker(apiKey: pixaBayApiKey, language: "en");

  Future<PixabayResponse?> getImagesByCategory() async {
    List<String> categoryList = Category.categories;
    String category = categoryList[Random().nextInt(categoryList.length)];
    log.wtf('Category:$category');
    return picker.api!.requestImages(resultsPerPage: 100, category: category);
  }

  Future<void> getImages() async {
    final response = await getImagesByCategory();
    images = response!.hits;
    notifyListeners();
  }
}
