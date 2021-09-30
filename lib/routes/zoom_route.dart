import 'package:flutter/material.dart';

Route zoomTransition({required Widget screen}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = 0.0;
      var end = 1.0;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return ScaleTransition(
        alignment: Alignment.topCenter,
        scale: animation.drive(tween),
        child: child,
      );
    },
  );
}