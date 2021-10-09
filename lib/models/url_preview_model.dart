import 'dart:typed_data';

class URLPreviewModel {
  final String url;
  final String title;
  final String discription;
  final Uint8List previewImage;

  URLPreviewModel({
    required this.url,
    required this.title,
    required this.discription,
    required this.previewImage,
  });

  factory URLPreviewModel.fromJson(Map<String, dynamic> json) {
    return URLPreviewModel(
        url: json['url'] as String,
        title: json['title'] as String,
        discription: json['discription'] as String,
        previewImage: json['previewImage'] as Uint8List);
  }
}

