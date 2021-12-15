import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';

class ExploreViewModel extends BaseViewModel {
  final log = getLogger('ExploreViewModel');

  List<PixabayMedia>? images = [];

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
    Category.people,
    Category.places,
    Category.religion,
    Category.science,
    Category.sports,
    Category.transportation,
    Category.travel,
  ];

  PixabayPicker picker = PixabayPicker(apiKey: pixaBayApiKey, language: "en");


// Future<TenorResponse?> requestTrendingGIF({
//   int limit = 20,
//   ContentFilter contentFilter = ContentFilter.off,
//   GifSize size = GifSize.all,
//   MediaFilter mediaFilter = MediaFilter.minimal,
// })

// fetch trending Gif


  Future<PixabayResponse?> getImagesByCategory() async {
    String category = categoriesList[Random().nextInt(categoriesList.length)];
    log.wtf('Category:$category');
    return picker.api!.requestImages(resultsPerPage: 100, category: category);
  }

  Future<void> fetchNext() async {
    setBusy(true);
    log.wtf('Reach to bottom');
    final response = await getImagesByCategory();
    final mediaList = response!.hits;
    log.wtf('Loading More Images');
    for (var media in mediaList!) {
      images!.add(media);
    }
    setBusy(false);
  }

  Future<void> getImages() async {
    final response = await getImagesByCategory();
    images = response!.hits;
    notifyListeners();
  }
}
