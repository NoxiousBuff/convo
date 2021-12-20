class PixabayImageModel {
  // int id;
  // String pageURL;
  // String type;
  // List<String> tags;
  // String previewURL;
  // int previewWidth;
  // int previewHeight;
  // String webformatURL;
  // String webformatWidth;
  // String webformatHeight;
  // String largeImageURL;
  // String fullHDURL;
  // String imageURL;
  // int imageWidth;
  // int imageHeight;
  // int imageSize;
  // int views;
  // int downloads;
  // int likes;
  // int comments;
  // int user_id;
  // String user;
  // String userImageURL;

  String type;
  String tags;
  String previewURL;
  String webformatURL;
  // String imageURL;
  int imageWidth;
  int imageHeight;
  int views;
  String user;
  String userImageURL;

  PixabayImageModel({
    required this.imageHeight,
    // required this.imageURL,
    required this.imageWidth,
    required this.previewURL,
    required this.tags,
    required this.type,
    required this.user,
    required this.userImageURL,
    required this.views,
    required this.webformatURL,
  });

  factory PixabayImageModel.fromJson(Map<String, dynamic> json) {
    return PixabayImageModel(
      imageHeight : json['imageHeight'],
      // imageURL : json['imageURL'],
      imageWidth : json['imageWidth'],
      previewURL : json['previewURL'],
      tags : json['tags'],
      type : json['type'],
      user : json['user'],
      userImageURL : json['userImageURL'],
      views : json['views'],
      webformatURL : json['webformatURL'],
    );
  }
}
