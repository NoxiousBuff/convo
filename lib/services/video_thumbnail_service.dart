import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final videoThumbnailService = VideoThumbnailService();

class VideoThumbnailService {

  final log = getLogger('VideoThumbnailService');

  Future<String> getThumbnailFromUrl(String videoURL) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    if (fileName != null) {
      return fileName;
    } else {
      log.e('The url is null');
      return '';
    }
  }
}
