// import 'package:hint/constants/app_strings.dart';
// import 'package:hint/extensions/custom_color_scheme.dart';
// import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
// import 'package:hint/ui/views/auth/auth_widgets.dart';

// import 'privacy_viewmodel.dart';
// import 'package:hive/hive.dart';
// import 'package:hint/api/hive.dart';
// import 'package:stacked/stacked.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hint/app/app_logger.dart';
// import 'package:hint/ui/shared/ui_helpers.dart';

// class PrivacyView extends StatelessWidget {
//   const PrivacyView({Key? key}) : super(key: key);

//   Widget heading({required BuildContext context, required String title}) {
//     return ListTile(
//       title: Text(
//         title,
//         style: Theme.of(context).textTheme.bodyText1,
//       ),
//     );
//   }

//   Future<void> dialog({
//     required String title,
//     required Widget optionsList,
//     required BuildContext context,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         final maxHeight = screenHeightPercentage(context, percentage: 0.3);
//         final maxWidth = screenWidthPercentage(context, percentage: 0.6);
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Container(
//             constraints: BoxConstraints(
//               maxHeight: maxHeight,
//               maxWidth: maxWidth,
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   alignment: Alignment.bottomLeft,
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   child: Text(
//                     title,
//                     style: Theme.of(context).textTheme.bodyText1,
//                   ),
//                 ),
//                 optionsList
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> lastSeenDialog(PrivacyViewModel model, BuildContext context) {
//     return dialog(
//       context: context,
//       title: 'Last Seen',
//       optionsList: ListView.builder(
//         shrinkWrap: true,
//         itemCount: model.dialogptions.length,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: RadioListTile(
//               value: index,
//               activeColor: Theme.of(context).colorScheme.blue,
//               groupValue: model.lastSeenValue,
//               title: Text(
//                 model.dialogptions[index],
//                 style: Theme.of(context).textTheme.bodyText2,
//               ),
//               onChanged: (int? i) {
//                 model.currentIndex(i);
//                 getLogger('PrivacyView')
//                     .wtf("LastSeenValue:${model.lastSeenValue}");
//                 Navigator.pop(context);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> profilePhotoDialog(
//       PrivacyViewModel model, BuildContext context) {
//     return dialog(
//       context: context,
//       title: 'Profile Photo',
//       optionsList: ListView.builder(
//         shrinkWrap: true,
//         itemCount: model.dialogptions.length,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: RadioListTile(
//               value: index,
//               activeColor: Theme.of(context).colorScheme.blue,
//               groupValue: model.profileValue,
//               title: Text(
//                 model.dialogptions[index],
//                 style: Theme.of(context).textTheme.bodyText2,
//               ),
//               onChanged: (int? i) {
//                 model.photoValueIndex(i);
//                 getLogger('PrivacyView')
//                     .wtf("ProfilePhotValue:${model.profileValue}");
//                 Navigator.pop(context);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> aboutDialog(PrivacyViewModel model, BuildContext context) {
//     return dialog(
//       context: context,
//       title: 'About',
//       optionsList: ListView.builder(
//         shrinkWrap: true,
//         itemCount: model.dialogptions.length,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: RadioListTile(
//               value: index,
//               activeColor: Theme.of(context).colorScheme.blue,
//               groupValue: model.aboutValue,
//               title: Text(
//                 model.dialogptions[index],
//                 style: Theme.of(context).textTheme.bodyText2,
//               ),
//               onChanged: (int? i) {
//                 model.aboutValueIndex(i);
//                 getLogger('PrivacyView').wtf("AboutValue:${model.aboutValue}");
//                 Navigator.pop(context);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<PrivacyViewModel>.reactive(
//       viewModelBuilder: () => PrivacyViewModel(),
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
//           appBar: cwAuthAppBar(context,
//               title: 'Privacy', onPressed: () => Navigator.pop(context)),
//           body: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             children: [
//               Container(
//                 color: Theme.of(context).colorScheme.white,
//                 child: Column(
//                   children: [
//                     const CWEAHeading('Who can see \nmy personal info'),
//                     cwEADescriptionTitle(context,
//                         'If you don\'t share your username & online status, you won\'t be able to see others people details.'),
//                     verticalSpaceRegular,
//                     cwEADetailsTile(context, 'Online Status',
//                         onTap: () => lastSeenDialog(viewModel, context)),
//                     cwEADetailsTile(context, 'Profile photo',
//                         onTap: () => profilePhotoDialog(viewModel, context)),
//                     cwEADetailsTile(context, 'Bio',
//                         onTap: () => aboutDialog(viewModel, context)),
//                   ],
//                 ),
//               ),
//               verticalSpaceMedium,
//               ValueListenableBuilder<Box>(
//                 valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
//                 builder: (context, box, child) {
//                   const boxName = HiveApi.appSettingsBoxName;
//                   const key = AppSettingKeys.incognatedMode;
//                   bool incognatedMode =
//                       Hive.box(boxName).get(key, defaultValue: false);
//                   return Row(
//                     children: [
//                       Expanded(
//                           child: cwEADetailsTile(context, 'Incongnito Mode',
//                               subtitle:
//                                   'If you on this setting no one can see your your online status and your username in live chat',
//                               showTrailingIcon: false)),
//                               horizontalSpaceRegular,
//                       CupertinoSwitch(
//                       value: incognatedMode,
//                         onChanged: (val) {
//                           box.put(
//                               AppSettingKeys.incognatedMode, !incognatedMode);
//                         },
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
