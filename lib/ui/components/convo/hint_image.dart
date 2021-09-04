import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path.dart';
import 'dart:io';
import 'package:hive/hive.dart';

class HintImage extends StatefulWidget {
  //make sure that the hive box is already opened
  final String mediaUrl;
  final String? imageName;
  final String uuid;
  final String hiveBoxName;
  final String? folderPath;
  final VoidCallback? onTap;
  const HintImage({
    Key? key,
    required this.mediaUrl,
    required this.uuid,
    required this.hiveBoxName,
    this.folderPath,
    this.imageName,
    this.onTap,
  }) : super(key: key);

  @override
  _HintImageState createState() => _HintImageState();
}

class _HintImageState extends State<HintImage> {
  bool? hiveContainsPath;
  bool? isDeleted;
  String? savedFilePath = '';
  PathHelper pathHelper = PathHelper();
  HiveHelper hiveHelper = HiveHelper();
  DioHelper dioHelper = DioHelper();

  @override
  void initState() {
    hiveContainsPath = Hive.box(widget.hiveBoxName).containsKey(widget.uuid);
    savedFilePath = Hive.box(widget.hiveBoxName).get(widget.uuid);

    imageDecider();
    super.initState();
  }

  void generalWorker() async {
    await pathHelper.saveMediaAtPath(
      folderPath: widget.folderPath ?? 'Images/Samples',
      mediaName: widget.imageName ?? widget.uuid,
      mediaUrl: widget.mediaUrl,
      uuid: widget.uuid,
      hiveBoxName: widget.hiveBoxName,
    );
  }

  void imageDecider() async {
    if (hiveContainsPath!) {
      if (await File(savedFilePath!).exists()) {
        setState(() {
          isDeleted = false;
        });
        print('Path of the value given does exist');
      } else {
        setState(() {
          isDeleted = true;
        });
        print(
            'Path of the value does not exist.\n Here is the function starts.');
        generalWorker();
        print('Here functions ends');
      }
    } else {
      print('This is the middle else that is been printed.');
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
                child: Center(
                  child: Container(
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
                    Hive.box(widget.hiveBoxName).get(widget.uuid),
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
                      Text('Error Occurred');
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  fit: BoxFit.fitWidth,
                  imageUrl: widget.mediaUrl,
                ),
                Text('This is from Cached Network Image'),
              ],
            ),
          );
  }
}
