// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';

// class MediaPickers extends StatefulWidget {
//   @override
//   _MediaPickersState createState() => _MediaPickersState();
// }

// class _MediaPickersState extends State<MediaPickers> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           child: Text('Select Photos In Progress'),
//         ),
//       ),
//     );
//   }
// }

// class ImagePreview extends StatelessWidget {
//   final Uint8List? imageData;
//   ImagePreview({Key? key, this.imageData}) : super(key: key);

//   final PhotoViewScaleStateController _scaleStateController =
//       PhotoViewScaleStateController();
//   final PhotoViewController _photoViewController = PhotoViewController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           child: PhotoView(
//             heroAttributes: PhotoViewHeroAttributes(tag: imageData!),
//             imageProvider: MemoryImage(imageData!),
//             backgroundDecoration: BoxDecoration(color: Colors.white),
//             controller: _photoViewController,
//             scaleStateController: _scaleStateController,
//             scaleStateChangedCallback: (scaleState) {
//               _scaleStateController.outputScaleStateStream;
//             },
//             minScale: PhotoViewComputedScale.contained,
//             initialScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered,
//             loadingBuilder: (context, event) => Center(
//               child: Container(
//                 width: 20.0,
//                 height: 20.0,
//                 child: CircularProgressIndicator(
//                   value: event == null
//                       ? 0
//                       : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VideoPreview extends StatefulWidget {
//   const VideoPreview({Key? key}) : super(key: key);

//   @override
//   _VideoPreviewState createState() => _VideoPreviewState();
// }

// class _VideoPreviewState extends State<VideoPreview> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
