import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/background_downloader.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/video_thumbnail.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class VideoThumbnail extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String? imageName;
  final String hiveBoxName;
  final String folderPath;
  final VoidCallback? onTap;
  final String messageUid;
  const VideoThumbnail({
    Key? key,
    required this.mediaUrl,
    required this.hiveBoxName,
    required this.folderPath,
    this.imageName,
    this.onTap,
    required this.messageUid,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  bool hiveContainsPath = false;

  /// API
  DioApi dioApi = DioApi();
  PathHelper pathHelper = PathHelper();

  final log = getLogger('VideoThumbnail');

  void generalWorker() async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-IMG-$uploadingTime';
    await backDownloader.saveMediaAtPath(
      extension: 'mp4',
      mediaName: imageName,
      mediaURL: widget.mediaUrl,
      messageUid: widget.messageUid,
      folderPath: widget.folderPath,
    );
  }

  Widget downloadButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Download",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          horizontalSpaceTiny,
          Icon(FeatherIcons.arrowDown, color: Colors.white)
        ],
      ),
    );
  }

  /// Thumbnail Widget of video
  Widget videoThumbnail() {
    final hive =
        Hive.box(widget.hiveBoxName).get(widget.messageUid);
    final map = Map<String, dynamic>.from(hive);
    final path = VideoThumbnailModel.fromJson(map).videoThumbnailPath;
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(File(path)),
          CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.black.withOpacity(0.8),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                FeatherIcons.play,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        return box.containsKey(widget.messageUid)
            ? videoThumbnail()
            : GestureDetector(
                onTap: widget.onTap,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      placeholder: (context, string) {
                        if (string.isEmpty) {
                          const Text('Error Occurred');
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                      fit: BoxFit.fitWidth,
                      imageUrl: widget.mediaUrl,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: const Text(' '),
                    ),

                    CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          FeatherIcons.play,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     downloadButton(),
                    //     const Padding(
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    //       child: Text(
                    //         'Sorry, this media file appears to be missing',
                    //         style: TextStyle(color: Colors.white),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              );
      },
    );
  }
}
