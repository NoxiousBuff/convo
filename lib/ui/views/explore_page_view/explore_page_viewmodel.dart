import 'dart:math';

import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:stacked/stacked.dart';

class ExplorePageViewViewModel extends BaseViewModel {
  final log = getLogger('ExplorePageViewViewModel');
  PixabayPicker picker = PixabayPicker(apiKey: pixaBayApiKey);

  final List<PixabayMedia> _imagesList = [];
  List<PixabayMedia> get imagesList => _imagesList;

  void addToList(PixabayMedia image) {
    _imagesList.add(image);
    notifyListeners();
  }

  List<String> categoriesList = [
    Category.animals,
    Category.backgrounds,
    Category.buildings,
    Category.business,
    Category.computer,
    Category.education,
    Category.feelings,
    Category.food,
    Category.health,
    Category.industry,
    Category.music,
    Category.places,
    Category.religion,
    Category.science,
    Category.sports,
    Category.transportation,
    Category.travel,
  ];

  Future<void> fetchImages() async {
    try {
      var response = await getImages();
      var list = response!.hits;
      if (list != null) {
        for (var pixaBayMedia in list) {
          var url = pixaBayMedia.getThumbnailLink();
          if (url != null) addToList(pixaBayMedia);
        }
      } else {
        log.wtf('Image not fetched yet');
      }
    } catch (e) {
      log.e('fetchImages');
    }
  }

  Future<PixabayResponse?> getImages() async {
    String category = categoriesList[Random().nextInt(categoriesList.length)];
    log.w('Category:$category');
    return picker.api?.requestImages(resultsPerPage: 100, category: category);
  }
}
