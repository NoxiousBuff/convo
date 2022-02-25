import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/path.dart';
import 'package:hint/app/app_logger.dart';
import 'dart:io';
import 'package:hive/hive.dart';

class ConvoImage extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String? imageName;
  final String hiveBoxName;
  final String? folderPath;
  final VoidCallback? onTap;
  final String messageUid;
  const ConvoImage({
    Key? key,
    required this.mediaUrl,
    required this.hiveBoxName,
    this.folderPath,
    this.imageName,
    this.onTap,
    required this.messageUid,
  }) : super(key: key);

  @override
  _ConvoImageState createState() => _ConvoImageState();
}

class _ConvoImageState extends State<ConvoImage> {
  bool? hiveContainsPath;
  bool? isDeleted;
  String? savedFilePath = '';
  PathHelper pathHelper = PathHelper();
  DioApi dioApi = DioApi();

  @override
  void initState() {
    hiveContainsPath =
        Hive.box(widget.hiveBoxName).containsKey(widget.messageUid);
    savedFilePath = Hive.box(widget.hiveBoxName).get(widget.messageUid);

    imageDecider();
    super.initState();
  }

  void generalWorker() async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-IMG-$uploadingTime';
    await pathHelper.saveMediaAtPath(
      folderPath: widget.folderPath ?? 'Convo/Media/Images',
      mediaName: widget.imageName ?? imageName,
      mediaUrl: widget.mediaUrl,
      hiveBoxName: widget.hiveBoxName,
      messageUid: widget.messageUid,
    );
  }

  void imageDecider() async {
    if (hiveContainsPath!) {
      if (await File(savedFilePath!).exists()) {
        setState(() {
          isDeleted = false;
        });
        getLogger('Hint Image').wtf('Path of the value given does exist');
      } else {
        setState(() {
          isDeleted = true;
        });
        getLogger('Hint Image').wtf(
            'Path of the value does not exist.\n Here is the function starts.');
        generalWorker();
        getLogger('Hint Image').wtf('Here functions ends');
      }
    } else {
      getLogger('Hint Image')
          .wtf('This is the middle else that is been printed.');
      setState(() {
        isDeleted = false;
      });
      generalWorker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return hiveContainsPath ?? false
        ? isDeleted ?? false
            ? GestureDetector(
                onTap: () {
                  generalWorker();
                  setState(() {});
                },
                child: const Center(
                  child: SizedBox(
                    child: Text('You have deleted this image'),
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            : GestureDetector(
                onTap: widget.onTap,
                child: Image.file(
                  File(
                    Hive.box(widget.hiveBoxName).get(widget.messageUid),
                  ),
                ),
              )
        : GestureDetector(
            onTap: widget.onTap,
            child: Column(
              children: [
                CachedNetworkImage(
                  placeholder: (context, string) {
                    if (string.isEmpty) {
                      const Text('Error Occurred');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  fit: BoxFit.fitWidth,
                  imageUrl: widget.mediaUrl,
                ),
                const Text('This is from Cached Network Image'),
              ],
            ),
          );
  }
}
