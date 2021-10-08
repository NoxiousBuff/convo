import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/canvas_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_color_picker/fast_color_picker.dart';

class DrawingCanvas extends StatefulWidget {
  final String receiverUid;
  final String conversationId;
  const DrawingCanvas(
      {Key? key, required this.receiverUid, required this.conversationId})
      : super(key: key);

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late PainterController painterController;
  bool sliderPosition = false;

  static PainterController newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;

    return controller;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      painterController = newController();
    });
  }

  void showPicture(PictureDetails picture) {}

  Widget slider(PainterController controller) {
    return AnimatedPositioned(
      top: 100,
      left: sliderPosition ? 2 : -16,
      duration: const Duration(milliseconds: 100),
      child: RotatedBox(
        quarterTurns: 3,
        child: SizedBox(
          width: 200,
          child: CupertinoSlider(
            value: controller.thickness,
            onChanged: (double value) {
              setState(() {
                controller.thickness = value;
              });
            },
            onChangeStart: (double val) {
              setState(() {
                sliderPosition = true;
              });
            },
            onChangeEnd: (double val) {
              setState(() {
                sliderPosition = false;
              });
            },
            min: 1.0,
            max: 16.0,
            activeColor: activeBlue,
          ),
        ),
      ),
    );
  }

  Widget actionsIconWidget(
      {required IconData? iconData, void Function()? onPressed}) {
    return IconButton(
      icon: Icon(iconData, color: systemBackground),
      onPressed: onPressed,
    );
  }

  Widget painterControllers() {
    return Positioned(
      top: 0,
      child: SizedBox(
        height: 80,
        width: screenWidth(context),
        child: Material(
          color: Colors.transparent,
          child: Visibility(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                actionsIconWidget(
                  iconData: Icons.undo,
                  onPressed: () => painterController.undo(),
                ),
                actionsIconWidget(
                  iconData: CupertinoIcons.clear,
                  onPressed: () => painterController.clear(),
                ),
                actionsIconWidget(
                  iconData: painterController.eraseMode
                      ? CupertinoIcons.circle_fill
                      : CupertinoIcons.pencil,
                  onPressed: () {
                    setState(() {
                      painterController.eraseMode =
                          !painterController.eraseMode;
                    });
                  },
                ),
                TextButton(
                  onPressed: () async {
                    final boxId = widget.conversationId;
                    final messageUid = const Uuid().v1();
                    final hiveBox = Hive.box('ImagesMemory[$boxId]');
                    final imageData = await painterController.finish().toPNG();
                    await hiveBox.put(messageUid, imageData);

                    await chatService.addFirestoreMessage(
                      mediaURL: imageData,
                      type: canvasImageType,
                      messageUid: messageUid,
                      timestamp: Timestamp.now(),
                      receiverUid: widget.receiverUid,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Done',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: screenHeightPercentage(context, percentage: 0.5),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Painter(painterController),
              painterControllers(),
              slider(painterController),
              Positioned(
                bottom: 20,
                child: SizedBox(
                  height: 80,
                  width: screenWidth(context),
                  child: FastColorPicker(
                    icon: CupertinoIcons.paintbrush,
                    selectedColor: painterController.drawColor,
                    onColorSelected: (_color) {
                      setState(() {
                        painterController.drawColor = _color;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
