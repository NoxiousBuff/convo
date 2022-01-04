import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
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
  Widget mediaHandler(String type) {
    switch (type) {
      case MediaType.image:
        {
          return Center(child: ExtendedImage.network(widget.mediaUrl));
        }
      case MediaType.video:
        {
          return Center(child: VideoDisplayWidget(videoUrl: widget.mediaUrl));
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
      ),
      body: Container(
          height: screenHeight(context),
          width: screenWidth(context),
          color: Theme.of(context).colorScheme.black,
          child: mediaHandler(widget.mediaType)),
    );
  }
}