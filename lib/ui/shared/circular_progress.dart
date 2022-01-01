import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

class CircularProgress extends StatelessWidget {
  final double height;
  final double width;
  const CircularProgress({Key? key, this.height = 40, this.width = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).colorScheme.darkGrey,
        ),
      ),
    );
  }
}
