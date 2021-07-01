import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/helper/hive_helper.dart';
import 'package:hint/helper/path_helper.dart';
import 'package:hint/utilities/hint_video.dart';

class SamplePrototype extends StatefulWidget {
  const SamplePrototype({Key? key}) : super(key: key);

  @override
  _SamplePrototypeState createState() => _SamplePrototypeState();
}

class _SamplePrototypeState extends State<SamplePrototype> {
  Dio dio = Dio();
  PathHelper pathHelper = PathHelper();

  @override
  void initState() {
    super.initState();
  }

  String mediaUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Sample Prototype'),
      ),
      body: Center(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 50),
            children: [
              SizedBox(height: 20),
              HintVideo(
                mediaUrl: mediaUrl,
                uuid: '1',
                hiveBoxName: HiveHelper.hiveBoxVideo,
                folderPath: 'Hint Videos',
              )
            ],
          ),
        ),
      ),
    );
  }
}
