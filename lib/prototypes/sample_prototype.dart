import 'package:dio/dio.dart';
import 'package:hint/api/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      appBar: const CupertinoNavigationBar(
        middle: Text('Sample Prototype'),
      ),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 50),
          children:const [
             SizedBox(height: 20),
            // HintVideo(
            //   mediaUrl: mediaUrl,
            //   messageUid: '1',
            //   hiveBoxName: HiveHelper.hiveBoxVideo,
            //   folderPath: 'Hint Videos',
            // )
          ],
        ),
      ),
    );
  }
}
