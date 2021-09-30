import 'package:flutter/material.dart';

Route fadeTransition({required Widget enterTo}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => enterTo,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = 1.0;
      var end = 0.2;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation.drive(tween),
        child: child,
      );
    },
  );
}