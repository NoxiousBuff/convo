import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/video_thumbnail.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

/// Display OR save the thumbnail of each sended or recived video
class VideoThumbnailWidget extends StatelessWidget {
  final Message message;

  const VideoThumbnailWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          minWidth: MediaQuery.of(context).size.width * 0.1),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightGrey,
          borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),

        /// video Thumbnail is a widget of display video thumbnail
        /// This widget also save OR download the thumbnail of received video
        child: VideoThumbnail(
          message: message,

          /// Folder Path OR Name where the downloaded thumbnail of video saved
          folderPath: 'Media/Thumbnails',
          hiveBoxName: HiveApi.mediaHiveBox,
        ),
      ),
    );
  }
}
