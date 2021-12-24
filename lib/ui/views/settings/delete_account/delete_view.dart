// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hint/app/app_colors.dart';
// import 'package:hint/extensions/custom_color_scheme.dart';
// import 'package:hint/ui/views/auth/auth_widgets.dart';

// class DeleteMyAccount extends StatelessWidget {
//   const DeleteMyAccount({Key? key}) : super(key: key);

//   // Widget bulletins(String text) {
//   //   return Container(
//   //     margin: const EdgeInsets.symmetric(vertical: 8),
//   //     child: Row(
//   //       children: [
//   //         const SizedBox(width: 40),
//   //         Icon(CupertinoIcons.circle_fill,
//   //             color: Theme.of(context).colorScheme.darkGrey, size: 15),
//   //         const SizedBox(width: 10),
//   //         Text(text),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
//       appBar: cwAuthAppBar(context,
//           title: 'Security', onPressed: () => Navigator.pop(context)),
//       body: Column(
//         children: [
//           const SizedBox(height: 40),
//           Row(
//             children: [
//               const SizedBox(width: 40),
//                Icon(
//                 CupertinoIcons.exclamationmark_triangle_fill,
//                 color: Theme.of(context).colorScheme.red,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 'Deleting your account will:',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(color: Theme.of(context).colorScheme.red, fontSize: 16),
//               )
//             ],
//           ),
//           bulletins('Delete your account from Dule'),
//           bulletins('Erase you Letters'),
//           bulletins('Delete your all data'),
//           const SizedBox(height: 10),
//           const Divider(height: 0),
//           const SizedBox(height: 50),
//           const SizedBox(width: 50),
//           Row(
//             children: [
//               const SizedBox(width: 50),
//               Icon(
//                 CupertinoIcons.arrow_right_arrow_left_square,
//                 size: 30,
//                 color: Theme.of(context).colorScheme.darkGrey,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "Change email instead ?",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(color: Theme.of(context).colorScheme.mediumBlack),
//               ),
//             ],
//           ),
//           CupertinoButton.filled(
//             child: Text(
//               'Change Email',
//               style: Theme.of(context)
//                   .textTheme
//                   .button!
//                   .copyWith(color: Theme.of(context).colorScheme.white),
//             ),
//             onPressed: () {},
//           ),
//           const SizedBox(height: 180),
//           CupertinoButton(
//             color: Theme.of(context).colorScheme.red,
//             child: Text(
//               'Delete My Account',
//               style: Theme.of(context)
//                   .textTheme
//                   .button!
//                   .copyWith(color: Theme.of(context).colorScheme.white),
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
