import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HintImage extends StatefulWidget {
  //make sure that the hive box is already opened
  final String messageUid;
  final String mediaUrl;
  final String? imageName;
  final String hiveBoxName;
  final String folderPath;
  final VoidCallback? onTap;
  final String mediaPath;
  final String conversationId;
  const HintImage({
    Key? key,
    this.onTap,
    this.imageName,
    required this.mediaPath,
    required this.mediaUrl,
    required this.folderPath,
    required this.messageUid,
    required this.hiveBoxName,
    required this.conversationId,
  }) : super(key: key);

  @override
  _HintImageState createState() => _HintImageState();
}

class _HintImageState extends State<HintImage> {
  bool? isDeleted;
  DioApi dioApi = DioApi();
  bool hiveContainsPath = false;
  PathHelper pathHelper = PathHelper();
  HiveHelper hiveHelper = HiveHelper();

  @override
  void initState() {
    var hiveBox = Hive.box(widget.hiveBoxName);
    setState(() {
      hiveContainsPath = hiveBox.containsKey(widget.messageUid);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (!hiveContainsPath) {
      await pathHelper.saveMediaAtPath(
        mediaUrl: widget.mediaUrl,
        messageUid: widget.messageUid,
        folderPath: widget.folderPath,
        hiveBoxName: widget.hiveBoxName,
        mediaName: widget.imageName ?? widget.messageUid,
      );
    } else {
      //getLogger('HintImage').v('hive contain this path !!');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.2,
        maxWidth: MediaQuery.of(context).size.width * 0.6,
        minHeight: MediaQuery.of(context).size.width * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.35,
      ),
      child: hiveContainsPath
          ? GestureDetector(
              onTap: widget.onTap,
              child: ExtendedImage.file(
                File(
                  Hive.box(widget.hiveBoxName).get(widget.messageUid),
                ),
              ),
            )
          : GestureDetector(
              onTap: widget.onTap,
              child: CachedNetworkImage(
                placeholder: (context, child) => Image.file(File(widget.mediaPath)),
                imageUrl: widget.mediaUrl,
              ),
            ),
    );
  }
}
