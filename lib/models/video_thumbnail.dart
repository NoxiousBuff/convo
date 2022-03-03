import 'package:hint/constants/app_strings.dart';

class VideoThumbnailModel {
  final String videoThumbnailPath;
  final String localVideoPath;

  VideoThumbnailModel(
      {required this.localVideoPath, required this.videoThumbnailPath});

  VideoThumbnailModel.fromJson(Map<String, dynamic> json)
      : localVideoPath = json[VideoThumbnailField.localVideoPath],
        videoThumbnailPath = json[VideoThumbnailField.videoThumbnailPath];

  Map<String, dynamic> toJson() => {
        VideoThumbnailField.videoThumbnailPath: videoThumbnailPath,
        VideoThumbnailField.localVideoPath: localVideoPath,
      };
}
