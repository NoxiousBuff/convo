// import 'dart:math';
// import 'dart:ui';
// import 'dart:isolate';
// import 'offline_downloads.dart';
// import 'package:flutter/material.dart';
// import 'package:hint/api/path_finder.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

// class OnlineList extends StatefulWidget with WidgetsBindingObserver {
//   const OnlineList({Key? key}) : super(key: key);

//   @override
//   _OnlineListState createState() => _OnlineListState();
// }

// class _OnlineListState extends State<OnlineList> {
//   @override
//   void initState() {
//     //initialise();
//     super.initState();
//   }

//   void initialise() async {
//     /// Initialise the flutter downloader plugin
//     await FlutterDownloader.initialize(debug: true);
//     FlutterDownloader.registerCallback(downloadCallback);
//   }

//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     // if (debug) {
//     //   print(
//     //       'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//     // }
//     final SendPort send =
//         IsolateNameServer.lookupPortByName('downloader_send_port')!;
//     send.send([id, status, progress]);
//   }

//   final _urls = [
//     'https://firebasestorage.googleapis.com/v0/b/hint-72d23.appspot.com/o/ChatMedia%2FMarch%208%2C%202022%2FVID-202238-37154444.mp4?alt=media&token=555153b1-96bd-4f87-9505-bfbb1b21f5c5',
//     'https://firebasestorage.googleapis.com/v0/b/test-icurves.appspot.com/o/IntroScreenMediaContent%2Fandroid_apps.jpg?alt=media&token=e02ff99f-d4cf-4756-a782-69d5187af200',
//     'https://firebasestorage.googleapis.com/v0/b/test-icurves.appspot.com/o/IntroScreenMediaContent%2Fandroid_apps.jpg?alt=media&token=e02ff99f-d4cf-4756-a782-69d5187af200',
//     'https://firebasestorage.googleapis.com/v0/b/test-icurves.appspot.com/o/IntroScreenMediaContent%2Fandroid_apps.jpg?alt=media&token=e02ff99f-d4cf-4756-a782-69d5187af200',
//     'https://firebasestorage.googleapis.com/v0/b/test-icurves.appspot.com/o/IntroScreenMediaContent%2Fandroid_apps.jpg?alt=media&token=e02ff99f-d4cf-4756-a782-69d5187af200',
//     'https://firebasestorage.googleapis.com/v0/b/hint-72d23.appspot.com/o/ChatMedia%2FMarch%208%2C%202022%2FVID-202238-37154444.mp4?alt=media&token=555153b1-96bd-4f87-9505-bfbb1b21f5c5',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Online links'),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const OfflineDownloads(),
//             ),
//           );
//         },
//         label: const Text('Downloads'),
//       ),
//       body: SizedBox(
//         child: ListView.builder(
//           itemCount: _urls.length,
//           itemBuilder: (BuildContext context, int i) {
//             String _fileName = 'File ${i + 1}';
//             return Card(
//               elevation: 10,
//               child: Column(
//                 children: <Widget>[
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(_fileName),
//                       ),
//                       RawMaterialButton(
//                         textStyle: const TextStyle(color: Colors.blueGrey),
//                         onPressed: () => requestDownload(_urls[i], _fileName),
//                         child: const Icon(Icons.file_download),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> requestDownload(String _url, String _name) async {
//     // final dir =
//     //     await getApplicationDocumentsDirectory(); //From path_provider package
//     // var _localPath = dir.path + _name;
//     // final savedDir = Directory(_localPath);
//     // await savedDir.create(recursive: true).then((value) async {
//     //   String? _taskid = await FlutterDownloader.enqueue(
//     //     url: _url,
//     //     fileName: _name,
//     //     savedDir: _localPath,
//     //     showNotification: true,
//     //     openFileFromNotification: false,
//     //   );
//     //   print(_taskid);
//     //   log('savedDir:$savedDir');
//     // });
//     String path = await pathFinder.getSavedDirecotyPath('Media/Convo Videos');
//     await FlutterDownloader.enqueue(
//       url: _url,
//       savedDir: path,
//       fileName: 'VID-20220309${Random().nextInt(10)}-$_name.mp4',
//       showNotification: true,
//       openFileFromNotification: false,
//     );
//   }
// }
