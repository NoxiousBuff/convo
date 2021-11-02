// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:hint/app/app_logger.dart';
// import 'package:photo_manager/photo_manager.dart';

// class MediaPickerDemo extends StatelessWidget {
//   const MediaPickerDemo({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Media Picker Example',
//       theme: ThemeData(
//         // This is the theme of your application.
//         primarySwatch: Colors.red,
//       ),
//       home: const MyHomePage(title: 'Media Picker Example App'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title!),
//       ),
//       body: const MediaGrid(),
//     );
//   }
// }

// class MediaGrid extends StatefulWidget {
//   const MediaGrid({Key? key}) : super(key: key);

//   @override
//   _MediaGridState createState() => _MediaGridState();
// }

// class _MediaGridState extends State<MediaGrid> {
//   final log = getLogger('MediaGrid');
//   final List<Widget> _mediaList = [];
//   int currentPage = 0;
//   int lastPage = 0;
//   @override
//   void initState() {
//     super.initState();
//     _fetchNewMedia();
//   }

//   _handleScrollEvent(ScrollNotification scroll) {
//     if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
//       if (currentPage != lastPage) {
//         _fetchNewMedia();
//       }
//     }
//   }

//   _fetchNewMedia() async {
//     lastPage = currentPage;
//     var result = await PhotoManager.requestPermission();
//     if (result) {
//       // success
// //load the album list
//       List<AssetPathEntity> albums =
//           await PhotoManager.getAssetPathList(onlyAll: true);
//       log.wtf(albums);
//       List<AssetEntity> media =
//           await albums[0].getAssetListPaged(currentPage, 60);
//       log.wtf(media);
//       List<Widget> temp = [];
//       for (var asset in media) {
//         temp.add(
//           FutureBuilder(
//             future: asset.thumbDataWithSize(200, 200),
//             builder: (BuildContext context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 Uint8List data = snapshot.data as Uint8List;
//                 return Stack(
//                   children: <Widget>[
//                     Positioned.fill(
//                       child: Image.memory(
//                         data,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     if (asset.type == AssetType.video)
//                       const Align(
//                         alignment: Alignment.bottomRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(right: 5, bottom: 5),
//                           child: Icon(
//                             Icons.videocam,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//         );
//       }
//       setState(() {
//         _mediaList.addAll(temp);
//         currentPage++;
//       });
//     } else {
//       // fail
//       /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (ScrollNotification scroll) {
//         _handleScrollEvent(scroll);
//         return true;
//       },
//       child: GridView.builder(
//         itemCount: _mediaList.length,
//         gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//         itemBuilder: (BuildContext context, int index) {
//           return _mediaList[index];
//         },
//       ),
//     );
//   }
// }
