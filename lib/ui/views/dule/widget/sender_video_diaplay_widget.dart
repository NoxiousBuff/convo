import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/circular_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:extended_image/extended_image.dart';

class SenderVideoDisplayWidget extends StatefulWidget {
  final double uploadingProgress;
  final String videoPath;
  const SenderVideoDisplayWidget(
      {Key? key, required this.videoPath, required this.uploadingProgress})
      : super(key: key);

  @override
  _SenderVideoDisplayWidgetState createState() =>
      _SenderVideoDisplayWidgetState();
}

class _SenderVideoDisplayWidgetState extends State<SenderVideoDisplayWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    File file = File(widget.videoPath);
    setState(() {
      _controller = VideoPlayerController.file(file);
    });

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setVolume(1.0);
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
          return Container(
            constraints: const BoxConstraints(maxHeight: 35, maxWidth: 35),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: VideoPlayer(_controller)),
                Center(
                  child: Text(
                    (widget.uploadingProgress * 100).toInt().toString(),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgress(
              height: 30,
              width: 30,
            ),
          );
        }
      },
    );
  }
}
