import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';

class FullImage extends StatefulWidget {
  final messageUid;
  final String? photoUrl;
  final String? messageText;
  final String? hiveBoxName;

  const FullImage({
    required this.photoUrl,
    required this.messageText,
    required this.messageUid,
    required this.hiveBoxName,
  });

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  late bool hiveContainsPath;
  late String hivePath;
  double _opacity = 1.0;
  Duration fadeDuration = Duration(milliseconds: 300);
  PhotoViewScaleStateController _scaleStateController =
      PhotoViewScaleStateController();
  PhotoViewController _photoViewController = PhotoViewController();

  @override
  void initState() {
    hiveContainsPath =
        Hive.box(widget.hiveBoxName!).containsKey(widget.messageUid);
    hivePath = Hive.box(widget.hiveBoxName!).get(widget.messageUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.messageUid),
                backgroundDecoration: BoxDecoration(color: Colors.white),
                controller: _photoViewController,
                scaleStateController: _scaleStateController,
                scaleStateChangedCallback: (scaleState) {
                  _scaleStateController.outputScaleStateStream;
                },
                minScale: PhotoViewComputedScale.contained,
                initialScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
                imageProvider: FileImage(File(hivePath)),
                //imageProvider: hiveContainsPath ? FileImage(hivePath) : CachedNetworkImageProvider(widget.photoUrl!),
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // widget.messageText != null
        //     ? AnimatedOpacity(
        //         duration: fadeDuration,
        //         opacity: _opacity,
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Container(
        //             constraints: BoxConstraints(
        //               maxHeight: MediaQuery.of(context).size.height * 0.15,
        //               minWidth: 0,
        //               maxWidth: MediaQuery.of(context).size.width,
        //             ),
        //             decoration: BoxDecoration(
        //               gradient: LinearGradient(
        //                 begin: Alignment.bottomCenter,
        //                 end: Alignment.topCenter,
        //                 colors: [
        //                   Colors.black38,
        //                   Colors.transparent,
        //                 ],
        //               ),
        //             ),
        //             padding: EdgeInsets.all(12),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               mainAxisSize: MainAxisSize.max,
        //               children: [
        //                 Expanded(
        //                   child: SingleChildScrollView(
        //                     physics: BouncingScrollPhysics(),
        //                     child: Text(
        //                       widget.messageText!,
        //                       textAlign: TextAlign.center,
        //                       style: GoogleFonts.openSans(
        //                         fontSize: 14.0,
        //                         color: CupertinoColors.white,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink(),

        //todo: this is just the difference between two comments

        // AnimatedOpacity(
        //   duration: Duration(milliseconds: 300),
        //   opacity: _opacity,
        //   child: Align(
        //     alignment: Alignment.topCenter,
        //     child: Container(
        //       child: Column(
        //         children: [
        //           SizedBox(
        //             height: MediaQuery.of(context).viewPadding.top,
        //           ),
        //           ListTile(
        //             trailing: Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 IconButton(
        //                     icon: Icon(
        //                       Icons.star_border_outlined,
        //                       color: Colors.white,
        //                     ),
        //                     onPressed: () {}),
        //                 IconButton(
        //                     icon: Icon(
        //                       Icons.ios_share,
        //                       color: Colors.white,
        //                     ),
        //                     onPressed: () {})
        //               ],
        //             ),
        //             leading: IconButton(
        //               icon: Icon(Icons.arrow_back_ios_sharp),
        //               color: Colors.white,
        //               onPressed: () {},
        //             ),
        //             title: Text(
        //               'Nikki',
        //               style: GoogleFonts.openSans(
        //                 fontSize: 18.0,
        //                 color: CupertinoColors.white,
        //               ),
        //             ),
        //             subtitle: Text(
        //               '1 April 2021',
        //               style: GoogleFonts.openSans(
        //                 fontSize: 12.0,
        //                 color: Colors.white54,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
// onResize: () {
// print('Resize is activated Now');
// },
// movementDuration: const Duration(milliseconds: 1),
// resizeDuration: const Duration(milliseconds: 1),
// key: Key(widget.messageUid),
// direction: DismissDirection.down,
// onDismissed: (direction) {
// Navigator.pop(context);
// },
// behavior: HitTestBehavior.translucent,
//todo: here lies appbar
// appBar: AppBar(
//   leading: AbsorbPointer(
//     absorbing: _opacity != 1.0,
//     child: AnimatedOpacity(
//       duration: fadeDuration,
//       opacity: _opacity,
//       child: IconButton(
//         icon: Icon(Icons.arrow_back_ios),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     ),
//   ),
//   backgroundColor: Colors.transparent,
//   brightness: Brightness.dark,
//   elevation: 0.0,
//   flexibleSpace: AnimatedOpacity(
//     duration: fadeDuration,
//     opacity: _opacity,
//     child: Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.center,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.black.withOpacity(0.5),
//             Colors.transparent,
//           ],
//         ),
//       ),
//     ),
//   ),
//   title: AbsorbPointer(
//     absorbing: _opacity != 1.0,
//     child: AnimatedOpacity(
//       duration: fadeDuration,
//       opacity: _opacity,
//       child: Text(
//         'Nikki',
//         style: GoogleFonts.openSans(
//           fontSize: 18.0,
//           color: CupertinoColors.white,
//         ),
//       ),
//     ),
//   ),
//   actions: [
//     AbsorbPointer(
//       absorbing: _opacity != 1.0,
//       child: AnimatedOpacity(
//         duration: fadeDuration,
//         opacity: _opacity,
//         child: IconButton(
//           icon: Icon(
//             Icons.star_border_outlined,
//           ),
//           onPressed: () {
//             print('star is tapped');
//           },
//         ),
//       ),
//     ),
//     AbsorbPointer(
//       absorbing: _opacity != 1.0,
//       child: AnimatedOpacity(
//         duration: fadeDuration,
//         opacity: _opacity,
//         child: IconButton(
//           icon: Icon(
//             Icons.ios_share,
//           ),
//           onPressed: () {},
//         ),
//       ),
//     ),
//   ],
// ),
