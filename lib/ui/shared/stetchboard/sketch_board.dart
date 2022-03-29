// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hint/extensions/custom_color_scheme.dart';
// import 'package:scribble/scribble.dart';
// import 'package:hint/ui/shared/ui_helpers.dart';
// import 'package:hint/ui/shared/color_picker.dart';

// class StketchBoardview extends StatefulWidget {
//   final ScribbleNotifier notifier;
//   const StketchBoardview({Key? key, required this.notifier}) : super(key: key);

//   @override
//   State<StketchBoardview> createState() => _StketchBoardviewState();
// }

// class _StketchBoardviewState extends State<StketchBoardview> {
//   bool _position = false;
//   bool drawingMode = false;
//   double _strokeValue = 2.0;

//   Widget _scribbleOptions() {
//     return Positioned(
//       top: 2,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           IconButton(
//             onPressed: () {
//               setState(() {});
//             },
//             icon: const Icon(CupertinoIcons.pen),
//             color: Colors.white,
//           ),
//           CircleAvatar(
//             maxRadius: 14,
//             backgroundColor: Theme.of(context).colorScheme.blue,
//             child: const Icon(CupertinoIcons.arrow_up, size: 12),
//           ),
          
//         ],
//       ),
//     );
//   }

//   Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: FloatingActionButton.small(
//         tooltip: "Erase",
//         backgroundColor: const Color(0xFFF7FBFF),
//         elevation: isSelected ? 10 : 2,
//         shape: !isSelected
//             ? const CircleBorder()
//             : RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//         child: const Icon(Icons.remove, color: Colors.blueGrey),
//         onPressed: widget.notifier.setEraser,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scribble(notifier: widget.notifier, drawPen: true),
//         _scribbleOptions(),
//         AnimatedPositioned(
//           top: screenHeightPercentage(context, percentage: 0.2),
//           duration: const Duration(milliseconds: 300),
//           left: _position ? 3.0 : -1.0,
//           child: RotatedBox(
//             quarterTurns: 3,
//             child: SizedBox(
//               height: screenHeightPercentage(context, percentage: 0.02),
//               child: CupertinoSlider(
//                 max: 6.0,
//                 min: 2.0,
//                 value: _strokeValue,
//                 onChangeStart: (val) {
//                   setState(() {
//                     _position = true;
//                   });
//                 },
//                 onChanged: (val) {
//                   setState(() {
//                     _strokeValue = val;
//                     widget.notifier.setStrokeWidth(val);
//                   });
//                 },
//                 onChangeEnd: (val) {
//                   setState(() {
//                     _position = false;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -1,
//           child: ColorPicker(onColorSelected: (color) {
//             setState(() {
//               widget.notifier.setColor(color);
//             });
//           }),
//         )
//       ],
//     );
//   }
// }
