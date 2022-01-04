import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReceiverVideoDisplayWidget extends StatefulWidget {
  final String videoUrl;
  const ReceiverVideoDisplayWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _ReceiverVideoDisplayWidgetState createState() =>
      _ReceiverVideoDisplayWidgetState();
}

class _ReceiverVideoDisplayWidgetState
    extends State<ReceiverVideoDisplayWidget> {
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

    // Use the controller to loop the video.
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
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: VideoPlayer(_controller)),
              Icon(
                FeatherIcons.play,
                size: 16,
                color: Theme.of(context).colorScheme.white,
              ),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Padding(
            padding:  EdgeInsets.all(8.0),
            child: CircularProgress(height: 30, width: 30),
          );
        }
      },
    );
  }
}