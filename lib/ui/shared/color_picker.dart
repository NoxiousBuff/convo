import 'package:flutter/material.dart';
import 'package:fast_color_picker/fast_color_picker.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;
  const ColorPicker({Key? key, required this.onColorSelected})
      : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return FastColorPicker(
      selectedColor: Colors.black,
      onColorSelected: widget.onColorSelected,
    );
  }
}
