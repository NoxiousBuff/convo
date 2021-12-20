import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hint/models/pixabay_api_response.dart';
import 'package:hint/models/pixabay_image_model.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:http/http.dart' as http;

List<PixabayImageModel> parsePhotos(String responseBody) {

  final parsed = jsonDecode(responseBody).cast<String, dynamic>();

  final PixabayApiResponse apiResponse = PixabayApiResponse.fromJson(parsed);

  final pixabayHits = apiResponse.hits.map((e) {
    final ap = e as Map<String, dynamic>;
    final media = PixabayImageModel.fromJson(ap);
    return media;
  }).toList();

  return pixabayHits;
}

class ExplorViewModel extends BaseViewModel {
  final log = getLogger('ExplorViewModel');

  List<PixabayImageModel> _images = [];
  List<PixabayImageModel> get images => _images;

  int _imagesLength = 0;
  int get imagesLength => _imagesLength;

  Future<List<PixabayImageModel>> fetchImages() async {
    setBusy(true);
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=24560588-abd85a4f3224ed81eb7c4a1de&q=yellow+flowers&image_type=photo&pretty=true'));
    log.wtf(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final computeResult = await compute(parsePhotos, response.body);
      log.e(computeResult);
      _imagesLength = computeResult.length;
      _images = _images + computeResult;
      notifyListeners();
      setBusy(false);

      return computeResult;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
