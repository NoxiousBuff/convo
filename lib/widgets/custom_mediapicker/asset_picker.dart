// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';

// class MyMediaPicker extends StatefulWidget {
//   const MyMediaPicker({Key? key}) : super(key: key);

//   @override
//   _MyMediaPickerState createState() => _MyMediaPickerState();
// }

// class _MyMediaPickerState extends State<MyMediaPicker> {
//   Future<bool> permission() async {
//     var isGranted = await PhotoManager.requestPermissionExtend();
//     if (isGranted.isAuth) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<List<AssetPathEntity>> albums() async {
//     List<AssetPathEntity> deviceAlbums =
//         await PhotoManager.getAssetPathList(onlyAll: true);
//     return deviceAlbums;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
