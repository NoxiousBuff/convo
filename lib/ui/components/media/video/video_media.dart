import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
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
  final borderRadius = BorderRadius.circular(16);
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
    //var progress = model.uploadingProgress * 100;

    return isFileUploading
        ? Positioned(bottom: 5, left: 5, child: uploadingProgress())
        : TextButton(
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload, color: extraLightBackgroundGray),
                const SizedBox(width: 10),
                Text(
                  'Retry',
                  style: GoogleFonts.roboto(
                    fontSize: 15.0,
                    color: systemBackground,
                  ),
                )
              ],
            ),
          );
  }

  Widget videoWidget({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: extraLightBackgroundGray, width: 5),
      ),
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        minWidth: MediaQuery.of(context).size.width * 0.2,
        maxWidth: MediaQuery.of(context).size.width * 0.65,
        minHeight: MediaQuery.of(context).size.width * 0.2,
      ),
      child: child,
    );
  }

  Widget uploadingProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: systemBackground,
          value: widget.model.uploadingProgress,
        ),
        Opacity(
          opacity: 0.5,
          child: CircleAvatar(
            maxRadius: 18,
            backgroundColor: black54,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.clear,
                color: systemBackground,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageUid = widget.messageUid;
    final conversationId = widget.conversationId;
    final hiveBox = Hive.box("ChatRoomMedia[$conversationId]");
    setState(() {
      hiveContainPath = hiveBox.containsKey(messageUid);
    });
    if (hiveContainPath) {
      return videoWidget(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                  minWidth: MediaQuery.of(context).size.width * 0.2,
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minHeight: MediaQuery.of(context).size.width * 0.2,
                ),
                child: ExtendedImage(
                  image: MemoryImage(widget.videoThumbnail),
                ),
              ),
            ),
            const Center(
              child: CircleAvatar(
                maxRadius: 28,
                backgroundColor: black54,
                child: Center(
                  child: Icon(
                    CupertinoIcons.play_fill,
                    color: systemBackground,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return videoWidget(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                  minWidth: MediaQuery.of(context).size.width * 0.2,
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minHeight: MediaQuery.of(context).size.width * 0.2,
                ),
                child: ExtendedImage(
                  image: MemoryImage(widget.videoThumbnail),
                ),
              ),
            ),
            !hiveContainPath
                ? retryButton(onPressed: () {})
                : const Center(
                    child: CircleAvatar(
                      maxRadius: 28,
                      backgroundColor: black54,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.play_fill,
                          color: systemBackground,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
          ],
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
