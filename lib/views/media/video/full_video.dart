import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class FullVideo extends StatefulWidget {
  final String? mediaUrl;
  final String? messageText;
  final Timestamp? timestamp;
  final bool? isMe;

  FullVideo(
      {required this.mediaUrl,
      required this.messageText,
      this.timestamp,
      this.isMe});
  @override
  _FullVideoState createState() => _FullVideoState(
        mediaUrl: this.mediaUrl,
        messageText: this.messageText,
        timestamp: this.timestamp,
        isMe: this.isMe,
      );
}

class _FullVideoState extends State<FullVideo> {
  late VideoPlayerController _playerController;
  Future<void>? _initialiseVideoPlayer;
  final String? mediaUrl;
  final String? messageText;
  final Timestamp? timestamp;
  final bool? isMe;
  double _opacity = 1.0;
  Duration fadeDuration = Duration(milliseconds: 300);

  String durationFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _FullVideoState(
      {required this.mediaUrl,
      required this.messageText,
      this.timestamp,
      this.isMe});

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(mediaUrl!);
    _initialiseVideoPlayer = _playerController.initialize();
    _playerController.setLooping(true);
    _playerController.setVolume(_playerController.value.volume);
    _playerController.play();
    print(_playerController.value.volume);
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
        setState(() {
          _opacity = _opacity == 1.0 ? 0.0 : 1.0;
        });
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
        child: Scaffold(
          backgroundColor: Colors.black54,
          appBar: AppBar(
            leadingWidth: 30,
            leading: AbsorbPointer(
              absorbing: _opacity != 1.0,
              child: AnimatedOpacity(
                duration: fadeDuration,
                opacity: _opacity,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: AnimatedOpacity(
              duration: fadeDuration,
              opacity: _opacity,
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15)),
              ),
            ),
            title: AbsorbPointer(
              absorbing: _opacity != 1.0,
              child: AnimatedOpacity(
                duration: fadeDuration,
                opacity: _opacity,
                child: Text(
                  'Nikki',
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
            actions: [
              AbsorbPointer(
                absorbing: _opacity != 1.0,
                child: AnimatedOpacity(
                  duration: fadeDuration,
                  opacity: _opacity,
                  child: IconButton(
                    icon: Icon(
                      Icons.star_border_outlined,
                    ),
                    onPressed: () {
                      print('star is tapped');
                    },
                  ),
                ),
              ),
              AbsorbPointer(
                absorbing: _opacity != 1.0,
                child: AnimatedOpacity(
                  duration: fadeDuration,
                  opacity: _opacity,
                  child: IconButton(
                    icon: Icon(
                      Icons.ios_share,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
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
                    Text(
                      durationFormat(_playerController.value.duration),
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 50),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _playerController,
                      builder: (context, value, child) {
                        return Text(
                          durationFormat(_playerController.value.position),
                          style: TextStyle(
                              color: CupertinoColors.white, fontSize: 50),
                        );
                      },
                    )
                  ],
                ),
                AbsorbPointer(
                  absorbing: _opacity != 1.0,
                  child: AnimatedOpacity(
                    duration: fadeDuration,
                    opacity: _opacity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (_playerController.value.isPlaying) {
                                _playerController.pause();
                              } else {
                                _playerController.play();
                              }
                            });
                          },
                          child: Icon(_playerController.value.isPlaying
                              ? Icons.pause_outlined
                              : Icons.play_arrow_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
                AbsorbPointer(
                  absorbing: _opacity != 1.0,
                  child: AnimatedOpacity(
                    duration: fadeDuration,
                    opacity: _opacity,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: VideoProgressIndicator(
                        _playerController,
                        allowScrubbing: true,
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
