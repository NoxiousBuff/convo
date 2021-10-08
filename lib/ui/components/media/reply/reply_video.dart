import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:video_player/video_player.dart';

class ReplyVideo extends StatefulWidget {
  final String? selectedMedia;
  const ReplyVideo({Key? key, required this.selectedMedia}) : super(key: key);

  @override
  _ReplyVideoState createState() => _ReplyVideoState();
}

class _ReplyVideoState extends State<ReplyVideo> {
  String? type;
  String? path;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.selectedMedia!);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

// Use the controller to loop the video.
    _controller.setLooping(true);

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
          return SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              children: [
                Center(
                  child: VideoPlayer(_controller),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    CupertinoIcons.video_camera,
                    color: systemBackground,
                  ),
                ),
              ],
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
