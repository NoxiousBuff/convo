// import 'dart:io';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// import 'account_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hint/app/app_colors.dart';
// import 'package:hint/app/app_logger.dart';
// import 'package:hint/models/user_model.dart';
// import 'package:hint/ui/shared/ui_helpers.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProfilePhoto extends StatelessWidget {
//   final FireUser fireUser;
//   final String? connection;
//   const ProfilePhoto(
//       {Key? key, required this.fireUser, required this.connection})
//       : super(key: key);

//   Widget option(
//       {required BuildContext context,
//       required String optionText,
//       void Function()? onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
//         child: Text(optionText, style: Theme.of(context).textTheme.bodyText2),
//       ),
//     );
//   }

//   Widget fileSizeDialog(BuildContext context) {
//     final shape =
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
//     return Dialog(
//       shape: shape,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         width: screenWidthPercentage(context, percentage: 0.4),
//         height: screenHeightPercentage(context, percentage: 0.2),
//         child: Text(
//           'file size exceed from 1 MB',
//           style: Theme.of(context).textTheme.bodyText2,
//         ),
//       ),
//     );
//   }

//   Widget offlineDialog(BuildContext context) {
//     final shape =
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
//     return Dialog(
//       shape: shape,
//       child: SizedBox(
//         width: screenWidthPercentage(context, percentage: 0.4),
//         height: screenHeightPercentage(context, percentage: 0.28),
//         child: Column(
//           children: [
//             Container(
//                 margin: const EdgeInsets.only(top: 20),
//                 child: const Icon(FeatherIcons.wifi,
//                     color: inactiveGray, size: 40)),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//               child: Text(
//                 'Internet Connection',
//                 style: Theme.of(context).textTheme.bodyText1,
//               ),
//             ),
//             const Divider(height: 0),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//               child: Text(
//                 'make sure you have an active internet connection',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyText2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final style = Theme.of(context).textTheme.bodyText1;
//     const margin = EdgeInsets.symmetric(vertical: 30, horizontal: 10);
//     final width = screenWidthPercentage(context, percentage: 0.4);
//     final height = screenHeightPercentage(context, percentage: 0.31);
//     final shape =
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
//     return InkWell(
//       onTap: () => showDialog(
//         context: context,
//         builder: (context) {
//           return Dialog(
//             shape: shape,
//             child: Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 color: systemBackground,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Consumer(
//                 builder: (_, watch, __) {
//                   final uid = fireUser.id;
//                   final viewModel = watch(userAccountProvider);

//                   return Column(
//                     children: [
//                       Container(
//                           margin: margin,
//                           child: Text('I want to', style: style)),
//                       const Divider(height: 0),
//                       option(
//                         context: context,
//                         optionText: 'Take Picture',
//                         onTap: () async {
//                           Navigator.pop(context);
//                           if (connection == 'Online') {
//                             await viewModel.pickImage(ImageSource.camera);
//                             final filePath = viewModel.pickedImage!.path;
//                             final fileLength = File(filePath).lengthSync();
//                             if (fileLength < 1000000) {
//                               await viewModel.uploadImage();
//                               await viewModel.updatePhoto(uid);
//                             } else {
//                               getLogger('ProfilePhoto')
//                                   .wtf('File Size is larger than 1 MB');
//                               showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return fileSizeDialog(context);
//                                 },
//                               );
//                             }
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return offlineDialog(context);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                       const Divider(height: 0),
//                       option(
//                         context: context,
//                         optionText: 'Remove Photo',
//                         onTap: () async {
//                           Navigator.pop(context);
//                           if (connection == 'Online') {
//                             viewModel.updatePhoto(fireUser.id);
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return offlineDialog(context);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                       const Divider(height: 0),
//                       option(
//                         context: context,
//                         optionText: 'Pick From Gallery',
//                         onTap: () async {
//                           Navigator.pop(context);
//                           if (connection == 'Online') {
//                             await viewModel.pickImage(ImageSource.gallery);
//                             String filePath = viewModel.pickedImage!.path;
//                             int fileLength = File(filePath).lengthSync();
//                             getLogger('ProfilePhoto')
//                                 .wtf('File was picked from gallery');
//                             try {
//                               if (fileLength < 1000000) {
//                                 await viewModel.uploadImage();
//                                 await viewModel.updatePhoto(uid);
//                               } else {
//                                 getLogger('ProfilePhoto')
//                                     .i('File Size is larger than 1 MB');
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return fileSizeDialog(context);
//                                   },
//                                 );
//                               }
//                             } catch (e) {
//                               getLogger('ProfilePhoto')
//                                   .e('showFileSizeDialog Error:$e');
//                             }
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return offlineDialog(context);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//       child: Container(
//         alignment: Alignment.centerLeft,
//         width: screenWidth(context),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: CircleAvatar(
//                 maxRadius: 30,
//                 backgroundImage: ExtendedNetworkImageProvider(fireUser.photoUrl),
//               ),
//             ),
//             Text(
//               fireUser.username,
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
