import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';

class VideoMedia extends StatefulWidget {
  final bool isMe;
  final String messageUid;
  final ChatViewModel model;
  final String conversationId;
  final Uint8List videoThumbnail;
  const VideoMedia({
    Key? key,
    required this.isMe,
    required this.model,
    required this.messageUid,
    required this.videoThumbnail,
    required this.conversationId,
  }) : super(key: key);

  @override
  _VideoMediaState createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  bool hiveContainPath = false;

  @override
  void initState() {
    super.initState();
    final messageUid = widget.messageUid;
    final conversationId = widget.conversationId;
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    setState(() {
      hiveContainPath = hiveBox.containsKey(messageUid);
    });
  }

  Widget retryButton({required void Function()? onPressed}) {
    final model = widget.model;
    final messageUid = widget.messageUid;
    bool isFileUploading = model.uploadingMessageUid == messageUid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: isFileUploading
          ? Center(
              child: Text("${model.uploadingProgress.toInt()}%",
                  style: GoogleFonts.roboto(
                      fontSize: 25.0, color: systemBackground)),
            )
          : TextButton(
              onPressed: onPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.upload, color: extraLightBackgroundGray),
                  SizedBox(width: 10),
                  Text(
                    'Retry',
                    style: TextStyle(color: systemBackground, fontSize: 15),
                  )
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageUid = widget.messageUid;
    final conversationId = widget.conversationId;
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    final decoration = BoxDecoration(borderRadius: BorderRadius.circular(20));
    setState(() {
      hiveContainPath = hiveBox.containsKey(messageUid);
    });
    if (hiveContainPath) {
      return Container(
        decoration: decoration,
        constraints: BoxConstraints(
          maxHeight: double.infinity,
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.width * 0.2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExtendedImage(
                  image: MemoryImage(widget.videoThumbnail),
                ),
              ),
              const Center(
                child: Icon(
                  CupertinoIcons.play_circle,
                  color: systemBackground,
                  size: 60,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: decoration,
        constraints: BoxConstraints(
          maxHeight: double.infinity,
          minWidth: MediaQuery.of(context).size.width * 0.2,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.width * 0.2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExtendedImage(
                  image: MemoryImage(widget.videoThumbnail),
                ),
              ),
              !hiveContainPath
                  ? retryButton(onPressed: () {})
                  : const Center(
                      child: Icon(
                        CupertinoIcons.play_circle,
                        color: systemBackground,
                        size: 60,
                      ),
                    ),
            ],
          ),
        ),
      );
    }
  }
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => FullVideo(
  //             mediaUrl: widget.videoPath,
  //             messageText: "widget.messageText",
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       constraints: BoxConstraints(
  //         minHeight: MediaQuery.of(context).size.width * 0.2,
  //         minWidth: MediaQuery.of(context).size.width * 0.2,
  //         maxHeight: double.infinity,
  //         maxWidth: MediaQuery.of(context).size.width * 0.8,
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(circularBorderRadius),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(circularBorderRadius),
  //         child: FutureBuilder(
  //           future: _initialiseVideoPlayer,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.done) {
  //               return Stack(
  //                 children: [
  //                   AspectRatio(
  //                     aspectRatio: _playerController.value.aspectRatio,
  //                     child: VideoPlayer(_playerController),
  //                   ),
  //                   const Positioned.fill(
  //                     child: Align(
  //                       alignment: Alignment.center,
  //                       child: CircleAvatar(
  //                         radius: 30,
  //                         backgroundColor: Colors.black54,
  //                         child: Icon(
  //                           Icons.play_arrow,
  //                           color: CupertinoColors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned.fill(
  //                     child: Align(
  //                       alignment: Alignment.topRight,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(20),
  //                           color: Colors.black54,
  //                         ),
  //                         padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
  //                         margin: const EdgeInsets.all(10),
  //                         child: ValueListenableBuilder(
  //                           valueListenable: _playerController,
  //                           builder: (context, value, child) => Text(
  //                             durationFormat(_playerController.value.duration),
  //                             style: const TextStyle(
  //                                 color: CupertinoColors.white, shadows: []),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getLogger('Video Media')
  //                           .wtf(snapshot.hasData.toString());
  //                     },
  //                     child: const Text('Check'),
  //                   )
  //                 ],
  //               );
  //             }
  //             return const Center(child: CupertinoActivityIndicator());
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
