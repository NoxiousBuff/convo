import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/components/media/video/full_video.dart';
import 'package:video_player/video_player.dart';

class VideoMedia extends StatefulWidget {
  final String? messageUid;
  final String? mediaUrl;
  final String? messageText;
  final Timestamp? timestamp;
  final bool isMe;

  const VideoMedia({Key? key, 
    required this.mediaUrl,
    required this.messageText,
    required this.timestamp,
    required this.isMe,
    required this.messageUid,
  }) : super(key: key);

  @override
  _VideoMediaState createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  final double circularBorderRadius = 28.0;

  final videoThumbnail =
      'https://images.unsplash.com/photo-1622492884727-08166c4ca044?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80';

  late VideoPlayerController _playerController;

  Future<void>? _initialiseVideoPlayer;

  String durationFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(widget.mediaUrl!);
    _initialiseVideoPlayer = _playerController.initialize();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullVideo(
              mediaUrl: widget.mediaUrl,
              messageText: widget.messageText,
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.width * 0.2,
              minWidth: MediaQuery.of(context).size.width * 0.2,
              maxHeight: double.infinity,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(circularBorderRadius),
              child: FutureBuilder(
                future: _initialiseVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _playerController.value.aspectRatio,
                          child: VideoPlayer(_playerController),
                        ),
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.play_arrow,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              margin: const EdgeInsets.all(10),
                              child: ValueListenableBuilder(
                                valueListenable: _playerController,
                                builder: (context, value, child) => Text(
                                  durationFormat(
                                      _playerController.value.duration),
                                  style: const TextStyle(
                                      color: CupertinoColors.white,
                                      shadows: []),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            getLogger('Video Media').wtf(snapshot.hasData.toString());
                          },
                          child: const Text('Check'),
                        )
                      ],
                    );
                  }

                  return const Center(child: CupertinoActivityIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
