import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class VideoDisplayWidget extends StatefulWidget {
  final String videoUrl;
  const VideoDisplayWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoDisplayWidgetState createState() => _VideoDisplayWidgetState();
}

class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(widget.videoUrl);

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.addListener(() {});

    // Use the controller to loop the video.
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: InkWell(
                    onTap: () {
                      setState(() {
                        _controller.pause();
                      });
                    },
                    child: VideoPlayer(_controller)),
              ),
              !_controller.value.isPlaying
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _controller.play();
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .black
                                .withOpacity(0.8),
                            shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Icon(
                          FeatherIcons.play,
                          size: 25,
                          color: Theme.of(context).colorScheme.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const CircularProgress();
        }
      },
    );
  }
}