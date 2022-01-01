import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/pixabay_image_model.dart';
import 'package:hint/models/pixabay_api_response.dart';

List<PixabayImageModel> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<String, dynamic>();

  final PixabayApiResponse apiResponse = PixabayApiResponse.fromJson(parsed);

  final pixabayHits = apiResponse.hits.map((e) {
    final json = e as Map<String, dynamic>;
    final media = PixabayImageModel.fromJson(json);

    return media;
  }).toList();

  return pixabayHits;
}

class ExplorViewModel extends BaseViewModel {
  final log = getLogger('ExplorViewModel');
  static const _key = pixaBayApiKey; // PixabayApiKey

  final List<PixabayImageModel> _fetchedImages = [];
  List<PixabayImageModel> get fetchedImages => _fetchedImages;

  static const hiveKey = FireUserField.interests;
  static const hiveBox = HiveApi.userDataHiveBox;
  List currentInterests = hiveApi.getFromHive(hiveBox, hiveKey);

  static List<String> categories = [
    'fashion',
    'nature',
    'backgrounds',
    'science',
    'education',
    'people',
    'feelings',
    'religion',
    'health',
    'places',
    'animals',
    'industry',
    'food',
    'computer',
    'sports',
    'transportation',
    'travel',
    'buildings',
    'business',
    'music'
  ];

  Future<List<PixabayImageModel>> fetchImages() async {
    List<dynamic> queries = currentInterests + categories;

    String query = queries[Random().nextInt(queries.length)];
    int random = Random().nextInt(10);

    int page = random + 1;

    log.wtf('Query:$query');
    log.v('PageNumber:$page');

    setBusy(true);
    String pixabayUrl =
        'https://pixabay.com/api/?key=$_key&q=$query&image_type=photo&pretty=true&per_page=6&page=$page&safesearch=true';

    Timer(const Duration(seconds: 4), () => setBusy(false));

    final response = await http.get(Uri.parse(pixabayUrl));
    log.wtf(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final computeResult = await compute(parsePhotos, response.body);
      log.v(computeResult);

      _fetchedImages.addAll(computeResult.reversed);
      log.wtf('Total Length Of Fetched Images:${_fetchedImages.length}');

      computeResult.isEmpty ? null : setBusy(false);
      return computeResult;
    } else {
      setBusy(false);
      throw Exception('Failed to load album');
    }
  }

  Future<List<PixabayImageModel>> initialFetch() async {
    List<dynamic> queries = currentInterests + categories;

    String query = queries[Random().nextInt(queries.length)];
    int random = Random().nextInt(10);

    int page = random + 1;

    log.wtf('Query:$query');
    log.v('PageNumber:$page');

    String pixabayUrl =
        'https://pixabay.com/api/?key=$_key&q=$query&image_type=photo&pretty=true&per_page=6&page=$page&safesearch=true';

    Timer(const Duration(seconds: 4), () => setBusy(false));

    final response = await http.get(Uri.parse(pixabayUrl));
    log.wtf(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final computeResult = await compute(parsePhotos, response.body);
      log.v(computeResult);

      _fetchedImages.addAll(computeResult.reversed);
      log.wtf('Total Length Of Fetched Images:${_fetchedImages.length}');

      return computeResult;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
