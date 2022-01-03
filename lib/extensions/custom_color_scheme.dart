import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color dynamicColor({required int light, required int dark}) {
    return (brightness == Brightness.light) ? Color(light) : Color(dark);
  }

  Color dynamicColour({required Color light, required Color dark}) {
    return (brightness == Brightness.light) ? light : dark;
  }

  bool get isDarkTheme => brightness != Brightness.light;

  Color get blue => dynamicColour(
      light: const Color.fromRGBO(0, 132, 255, 1),
      dark: const Color.fromRGBO(0, 132, 255, 1));

  Color get blueAccent => dynamicColour(
      light: const Color.fromRGBO(192, 229, 255, 1),
      dark: const Color.fromRGBO(6, 64, 111, 1));

  Color get red => dynamicColour(
      light: const Color.fromRGBO(255, 78, 78, 1),
      dark: const Color.fromRGBO(255, 122, 122, 1));

  Color get redAccent => dynamicColour(
      light: const Color.fromRGBO(255, 216, 215, 1),
      dark: const Color.fromRGBO(62, 14, 13, 1));

  Color get green => dynamicColour(
      light: const Color.fromRGBO(52, 199, 89, 1),
      dark: const Color.fromRGBO(52, 199, 89, 1));

  Color get greenAccent => dynamicColour(
      light: const Color.fromRGBO(187, 245, 213, 1),
      dark: const Color.fromRGBO(13, 85, 55, 1));

  Color get yellow => dynamicColour(
      light: const Color.fromRGBO(255, 193, 102, 1),
      dark: const Color.fromRGBO(255, 193, 102, 1));

  Color get yellowAccent => dynamicColour(
      light: const Color.fromRGBO(255, 234, 203, 1),
      dark: const Color.fromRGBO(82, 49, 0, 1));

  Color get purple => dynamicColour(
      light: const Color.fromRGBO(150, 147, 230, 1),
      dark: const Color.fromRGBO(150, 147, 230, 1));

  Color get purpleAccent => dynamicColour(
      light: const Color.fromRGBO(213, 212, 245, 1),
      dark: const Color.fromRGBO(39, 42, 44, 1));

  Color get lightGrey => dynamicColour(
      light: const Color.fromRGBO(243, 244, 246, 1),
      dark: Colors.grey.shade800);

  Color get grey => dynamicColour(
      light: const Color.fromRGBO(238, 239, 242, 1),
      dark: Colors.grey.shade700);

  Color get darkGrey => dynamicColour(
      light: const Color.fromRGBO(215, 217, 224, 1),
      dark: Colors.grey.shade500);

  Color get lightBlack =>
      dynamicColour(light: Colors.black38, dark: Colors.white24);

  Color get mediumBlack =>
      dynamicColour(light: Colors.black54, dark: Colors.white54);

  Color get black =>
      dynamicColour(light: Colors.black87, dark: const Color.fromRGBO(255, 255, 255, 0.87));

  Color get scaffoldColor =>
      dynamicColour(light: Colors.white, dark: const Color(0xff121212));

  Color get white => dynamicColour(light: Colors.white, dark: Colors.white);
}
