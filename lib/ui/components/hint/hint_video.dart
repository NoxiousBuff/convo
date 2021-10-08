import 'dart:io';
import 'dart:typed_data';
import 'package:hint/app/app_logger.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:string_validator/string_validator.dart';

class HintVideo extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String messageUid;
  final String hiveBoxName;
  final String folderPath;
  final Uint8List videoThumbnail;
  const HintVideo({
    Key? key,
    required this.mediaUrl,
    required this.messageUid,
    required this.hiveBoxName,
    required this.folderPath,
    required this.videoThumbnail,
  }) : super(key: key);

  @override
  _HintVideoState createState() => _HintVideoState();
}

class _HintVideoState extends State<HintVideo> {
  bool hiveContainsPath = false;
  late Uint8List videoThumbnail;
  PathHelper pathHelper = PathHelper();
  HiveHelper hiveHelper = HiveHelper();
  DioApi dioApi = DioApi();
  late VideoPlayerController _playerController;
  Future<void>? _initialiseVideoPlayer;

  @override
  void initState() {
    var hiveBox = Hive.box(widget.hiveBoxName);
    setState(() {
      videoThumbnail = widget.videoThumbnail;
      hiveContainsPath = hiveBox.containsKey(widget.messageUid);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    var hiveBox = Hive.box(widget.hiveBoxName);
    if (!hiveContainsPath) {
      if (isURL(widget.mediaUrl)) {
        getLogger('HintVideo').wtf('MediaURL:${widget.mediaUrl}');
        await pathHelper.saveMediaAtPath(
          mediaUrl: widget.mediaUrl,
          messageUid: widget.messageUid,
          folderPath: widget.folderPath,
          hiveBoxName: widget.hiveBoxName,
          mediaName: '${widget.messageUid}.mp4',
        );
      }
    } else {
      _playerController =
          VideoPlayerController.file(File(hiveBox.get(widget.messageUid)));
      _initialiseVideoPlayer = _playerController.initialize();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (hiveContainsPath) {
      case true:
        {
          return FutureBuilder(
            future: _initialiseVideoPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _playerController.value.aspectRatio,
                  child: VideoPlayer(_playerController),
                );
              }
              return const CupertinoActivityIndicator();
            },
          );
        }

      case false:
        {
          return ExtendedImage.memory(widget.videoThumbnail);
        }
      default:
        {
          return const SizedBox.shrink();
        }
    }
  }
}
