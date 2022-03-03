import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/background_downloader.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/convo_image/convo_image_viewmodel.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

class ConvoImage extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String? imageName;
  final String hiveBoxName;
  final String folderPath;
  final VoidCallback? onTap;
  final String messageUid;
  const ConvoImage({
    Key? key,
    required this.mediaUrl,
    required this.hiveBoxName,
    required this.folderPath,
    this.imageName,
    this.onTap,
    required this.messageUid,
  }) : super(key: key);

  @override
  _ConvoImageState createState() => _ConvoImageState();
}

class _ConvoImageState extends State<ConvoImage> {
  /// Booleans For Image Checking
  bool isDeleted = false;
  bool hiveContainsPath = false;

  /// API
  DioApi dioApi = DioApi();
  PathHelper pathHelper = PathHelper();

  final log = getLogger('ConvoImage');

  // @override
  // void initState() {
  //   setState(() {
  //     hiveContainsPath =
  //         Hive.box(widget.hiveBoxName).containsKey(widget.messageUid);
  //   });

  //   imageDecider();
  //   super.initState();
  // }

  void generalWorker() async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-IMG-$uploadingTime';
    await backDownloader.saveMediaAtPath(
      extension: 'jpeg',
      mediaName: imageName,
      mediaURL: widget.mediaUrl,
      messageUid: widget.messageUid,
      folderPath: widget.folderPath,
    );
    // await pathHelper.saveMediaAtPath(
    //   folderPath: widget.folderPath,
    //   mediaName: widget.imageName ?? imageName,
    //   mediaUrl: widget.mediaUrl,
    //   hiveBoxName: widget.hiveBoxName,
    //   messageUid: widget.messageUid,
    // );
  }

  // void imageDecider() async {
  //   // if (hiveContainsPath) {
  //   //   if (await File(savedFilePath).exists()) {
  //   //     setState(() {
  //   //       isDeleted = false;
  //   //     });
  //   //     getLogger('Hint Image').wtf('Path of the value given does exist');
  //   //   } else {
  //   //     setState(() {
  //   //       isDeleted = true;
  //   //     });
  //   //     getLogger('Hint Image').wtf(
  //   //         'Path of the value does not exist.\n Here is the function starts.');
  //   //     generalWorker();
  //   //     getLogger('Hint Image').wtf('Here functions ends');
  //   //   }
  //   // } else {
  //   //   getLogger('Hint Image')
  //   //       .wtf('This is the middle else that is been printed.');
  //   //   setState(() {
  //   //     isDeleted = false;
  //   //   });
  //   //   generalWorker();
  //   // }
  //   if (hiveContainsPath) {
  //     log.w('MessageUid:${widget.messageUid} hive contain path');
  //   } else {
  //     generalWorker();
  //     log.w(
  //         'MessageUid:${widget.messageUid} Image is downloading now because hive doesn\'t contain path');
  //   }
  // }

  Widget downloadButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Download",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          horizontalSpaceTiny,
          Icon(FeatherIcons.arrowDown, color: Colors.white)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        return ViewModelBuilder<ConvoImageViewModel>.reactive(
          viewModelBuilder: () => ConvoImageViewModel(),
          onModelReady: (model) {
            // if (box.containsKey(widget.messageUid)) {
            //   log.w('MessageUid:${widget.messageUid} hive contain path');
            // } else {
            //   generalWorker();
            //   log.w('Uid:${widget.messageUid} Image is downloading now');
            // }
          },
          builder: (context, model, child) {
            return box.containsKey(widget.messageUid)
                ? GestureDetector(
                    onTap: widget.onTap,
                    child: Image.file(File(
                        Hive.box(widget.hiveBoxName).get(widget.messageUid))),
                  )
                : GestureDetector(
                    onTap: widget.onTap,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, string) {
                            if (string.isEmpty) {
                              const Text('Error Occurred');
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          fit: BoxFit.fitWidth,
                          imageUrl: widget.mediaUrl,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: const Text(' '),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            downloadButton(),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                'Sorry, this media file appears to be missing',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
          },
        );
      },
    );
    // return hiveContainsPath
    //     ? isDeleted
    //         ? GestureDetector(
    //             onTap: () {
    //               generalWorker();
    //               setState(() {});
    //             },
    //             child: const Center(
    //               child: SizedBox(
    //                 child: Text('You have deleted this image'),
    //                 height: 100,
    //                 width: 100,
    //               ),
    //             ),
    //           )
    //         : GestureDetector(
    //             onTap: widget.onTap,
    //             child: Image.file(
    //                 File(Hive.box(widget.hiveBoxName).get(widget.messageUid))))
    //     : GestureDetector(
    //         onTap: widget.onTap,
    //         child: Column(
    //           children: [
    //             CachedNetworkImage(
    //               placeholder: (context, string) {
    //                 if (string.isEmpty) {
    //                   const Text('Error Occurred');
    //                 }
    //                 return const Center(child: CircularProgressIndicator());
    //               },
    //               fit: BoxFit.fitWidth,
    //               imageUrl: widget.mediaUrl,
    //             ),
    //             const Text('This is from Cached Network Image'),
    //           ],
    //         ),
    //       );
  }
}
