import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

class AnimationOptionChip extends StatefulWidget {
  final String label;
  final void Function() onTap;
  const AnimationOptionChip(
      {Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  State<AnimationOptionChip> createState() => _AnimationOptionChipState();
}

class _AnimationOptionChipState extends State<AnimationOptionChip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Chip(
        backgroundColor: Theme.of(context).colorScheme.lightBlack,
        label: Text(
          widget.label,
          style: TextStyle(color: Theme.of(context).colorScheme.white),
        ),
      ),
    );
  }
}
