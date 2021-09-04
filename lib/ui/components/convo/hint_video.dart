import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';

class HintVideo extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String? videoName;
  final String uuid;
  final String hiveBoxName;
  final String? folderPath;
  final VoidCallback? onTap;
  const HintVideo({
    Key? key,
    required this.mediaUrl,
    required this.uuid,
    required this.hiveBoxName,
    required this.folderPath,
    this.videoName,
    this.onTap,
  }) : super(key: key);

  @override
  _HintVideoState createState() => _HintVideoState();
}

class _HintVideoState extends State<HintVideo> {
  bool? hiveContainsPath;
  bool? isDeleted;
  String? savedFilePath = '';
  PathHelper pathHelper = PathHelper();
  HiveHelper hiveHelper = HiveHelper();
  DioHelper dioHelper = DioHelper();
  late VideoPlayerController _playerController;
  Future<void>? _initialiseVideoPlayer;

  @override
  void initState() {
    hiveContainsPath = Hive.box(widget.hiveBoxName).containsKey(widget.uuid);
    savedFilePath = Hive.box(widget.hiveBoxName).get(widget.uuid);
    videoDecider();
    _playerController = hiveContainsPath ?? false
        ? VideoPlayerController.file(File(savedFilePath!))
        : VideoPlayerController.network(widget.mediaUrl);
    _playerController.setLooping(true);
    // _playerController.play();
    _initialiseVideoPlayer = _playerController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  void generalWorker() async {
    await pathHelper.saveMediaAtPath(
      folderPath: widget.folderPath ?? 'Videos/Samples',
      mediaName: widget.videoName ?? widget.uuid,
      mediaUrl: widget.mediaUrl,
      uuid: widget.uuid,
      hiveBoxName: widget.hiveBoxName,
    );
  }

  void videoDecider() async {
    if (hiveContainsPath!) {
      if (await File(savedFilePath!).exists()) {
        setState(() {
          isDeleted = false;
        });
        print('Path of the value given does exist');
      } else {
        setState(() {
          isDeleted = true;
        });
        print(
            'Path of the value does not exist.\n Here is the function starts.');
        generalWorker();
        print('Here functions ends');
      }
    } else {
      print('This is the middle else that is been printed.');
      setState(() {
        isDeleted = false;
      });
      generalWorker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return hiveContainsPath ?? false
        ? isDeleted ?? false
            ? Center(
                child: TextButton(
                  onPressed: () {
                    generalWorker();
                  },
                  child: Text('Download Again'),
                ),
              )
            : Column(
                children: [
                  FutureBuilder(
                    future: _initialiseVideoPlayer,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _playerController.value.aspectRatio,
                          child: VideoPlayer(_playerController),
                        );
                      }
                      return CupertinoActivityIndicator();
                    },
                  ),
                  Text(' This is from Hive')
                ],
              )
        : Column(
            children: [
              FutureBuilder(
                future: _initialiseVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _playerController.value.aspectRatio,
                      child: VideoPlayer(_playerController),
                    );
                  }
                  return CupertinoActivityIndicator();
                },
              ),
              Text(' This is from Network.')
            ],
          );
  }
}
