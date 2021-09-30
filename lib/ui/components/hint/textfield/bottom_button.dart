import 'package:flutter/material.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.context,
    required this.widget,
    required this.onTap,
    required this.imageProvider,
  }) : super(key: key);

  final BuildContext context;
  final HintTextField widget;
  final VoidCallback onTap;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    double bottomWidth = (MediaQuery.of(context).size.width - 72.0) / 6;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: bottomWidth,
        padding: const EdgeInsets.all(4),
        child: Image(image: imageProvider),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: widget.randomColor!.withAlpha(50),
          borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(image: imageProvider)),
        ),
      ),
    );
  }
}
