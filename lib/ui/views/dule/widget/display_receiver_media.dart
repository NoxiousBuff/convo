import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/dule/widget/video_display_widget.dart';

class DisplayFullMedia extends StatefulWidget {
  const DisplayFullMedia({
    Key? key,
    required this.mediaType,
    required this.mediaUrl,
  }) : super(key: key);

  final String mediaType;
  final String mediaUrl;

  @override
  _DisplayFullMediaState createState() => _DisplayFullMediaState();
}

class _DisplayFullMediaState extends State<DisplayFullMedia> {
  Widget mediaHandler() {
    switch (widget.mediaType) {
      case MediaType.image:
        {
          return ExtendedImage.network(widget.mediaUrl);
        }
      case MediaType.video:
        {
          return VideoDisplayWidget(
            videoUrl: widget.mediaUrl,
            isPlayable: true,
          );
        }
      default:
        {
          return const Text('Media is coming...');
        }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: mediaHandler(),
      ),
    );
  }
}
