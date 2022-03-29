import 'dart:ui';
import '../color_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scribble/scribble.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/scribble/scribble_viewmodel.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class ScribbleView extends StatefulWidget {
  final FireUser fireUser;
  final ScribbleNotifier notifier;
  const ScribbleView(this.notifier, this.fireUser, {Key? key})
      : super(key: key);

  @override
  State<ScribbleView> createState() => _ScribbleViewState();
}

class _ScribbleViewState extends State<ScribbleView> {
  /// decides wether options are visible or not
  /// If it's value is true then option will display if not then options 
  /// will disappear
  bool _isVisible = false;
  final double _iconSize = 20;
  final double _maxRadius = 16;
  Color grey = Colors.grey;
  Color transparent = Colors.transparent;

  /// option widget of scribble
  /// This will display the options of the drawing also hold the visibility
  Widget _optionButton(
      {required IconData icon,
      Color? backgroundColor,
      required void Function()? onPressed}) {
    return Visibility(
      visible: !_isVisible,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            maxRadius: _maxRadius,
            backgroundColor: backgroundColor,
            child: Icon(icon, color: Colors.white, size: _iconSize),
          ),
        ),
      ),
    );
  }

  /// Decides the visibility of options
  Widget _visibilityDetector() {
    return InkWell(
      onTap: () {
      /// switch the visibility of scribble options and colors
        setState(() {
          _isVisible = !_isVisible;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          maxRadius: _maxRadius,
          backgroundColor: Colors.transparent,
          child: Icon(
            _isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
            size: _iconSize,
          ),
        ),
      ),
    );
  }

  /// you can see a preview of your drawing using this function
  Future<void> _saveImage(BuildContext context) async {
    final image = await widget.notifier.renderImage();
    final uint8listImage = Image.memory(image.buffer.asUint8List());
    File.fromRawPath(image.buffer.asUint8List());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Image"),
        content: uint8listImage,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  /// send your drawing
  /// This will convert your drawing into an image and then send it.
  Widget _sendButton(ScribbleViewModel model) {
    return Visibility(
      visible: !_isVisible,
      child: InkWell(
        onTap: () => model.uploadScribble(context, widget.notifier),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            maxRadius: 15,
            backgroundColor: CupertinoColors.activeBlue,
            child: Icon(CupertinoIcons.arrow_up, size: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScribbleViewModel>.reactive(
        viewModelBuilder: () => ScribbleViewModel(widget.fireUser),
        builder: (context, model, child) {
          return ClipRRect(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: const Text('.',
                      style: TextStyle(color: Colors.transparent)),
                ),
                Scribble(notifier: widget.notifier, drawPen: true),
                Positioned(
                  top: 2,
                  child: StateNotifierBuilder<ScribbleState>(
                    stateNotifier: widget.notifier,
                    builder: (context, state, _) {
                      return SizedBox(
                        width: screenWidth(context),
                        height: MediaQuery.of(context).size.height * .06,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            horizontalSpaceSmall,
                            _visibilityDetector(),
                            _optionButton(
                                icon: Icons.save,
                                backgroundColor: Colors.transparent,
                                onPressed: () => _saveImage(context)),
                            _optionButton(
                              icon: Icons.undo_rounded,
                              onPressed: widget.notifier.canUndo
                                  ? widget.notifier.undo
                                  : null,
                              backgroundColor:
                                  widget.notifier.canUndo ? grey : transparent,
                            ),
                            const Divider(height: 4.0),
                            _optionButton(
                              icon: Icons.redo_rounded,
                              onPressed: widget.notifier.canRedo
                                  ? widget.notifier.redo
                                  : null,
                              backgroundColor:
                                  widget.notifier.canRedo ? grey : transparent,
                            ),
                            const Divider(height: 4.0),
                            _optionButton(
                              icon: Icons.close,
                              backgroundColor: grey,
                              onPressed: widget.notifier.clear,
                            ),
                            const Divider(height: 20.0),
                            _buildPointerModeSwitcher(context,
                                penMode: state.allowedPointersMode ==
                                    ScribblePointerMode.penOnly),
                            const Divider(height: 20.0),
                            _buildEraserButton(context,
                                isSelected: state is Erasing),
                            const Divider(height: 32),
                            _buildStrokeToolbar(context),
                            _sendButton(model),
                            horizontalSpaceSmall,
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -1,
                  child: Visibility(
                    visible: !_isVisible,
                    child: ColorPicker(onColorSelected: (color) {
                      setState(() {
                        widget.notifier.setColor(color);
                      });
                    }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// creates the different storkes for drawing
  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: widget.notifier,
      builder: (context, state, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final w in widget.notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  /// stroke width button which notifies the stroke width
  Widget _buildStrokeButton(BuildContext context,
      {required double strokeWidth, required ScribbleState state}) {
    final selected = state.selectedWidth == strokeWidth;
    return Visibility(
      visible: !_isVisible,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          elevation: selected ? 4 : 0,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => widget.notifier.setStrokeWidth(strokeWidth),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              width: strokeWidth * 2,
              height: strokeWidth * 2,
              decoration: BoxDecoration(
                  color: state.map(
                    drawing: (s) => Color(s.selectedColor),
                    erasing: (_) => Colors.transparent,
                  ),
                  border: state.map(
                    drawing: (_) => null,
                    erasing: (_) => Border.all(width: 1),
                  ),
                  borderRadius: BorderRadius.circular(50.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context,
      {required bool penMode}) {
    return Visibility(
      visible: !_isVisible,
      child: InkWell(
        onTap: () => widget.notifier.setAllowedPointersMode(
          penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            maxRadius: _maxRadius,
            backgroundColor: Colors.blue,
            child: AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: !penMode
                  ? const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      key: ValueKey(true),
                    )
                  : const Icon(
                      Icons.do_not_touch,
                      color: Colors.white,
                      key: ValueKey(false),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// eraser button for erasing the drawing
  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Visibility(
      visible: !_isVisible,
      child: InkWell(
        onTap: widget.notifier.setEraser,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            maxRadius: _maxRadius,
            backgroundColor: isSelected ? Colors.black : Colors.white,
            child: Icon(
              Icons.remove,
              size: _iconSize,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
