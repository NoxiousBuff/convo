import 'package:flutter/material.dart';

Route cupertinoTransition({required Widget enterTo, required Widget exitFrom}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => enterTo,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Stack(
        children: [
          SlideTransition(
            position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(animation),
            child: enterTo,
          ),
          SlideTransition(
            position: Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0))
                .animate(animation),
            child: exitFrom,
          ),
        ],
      );
    },
  );
}