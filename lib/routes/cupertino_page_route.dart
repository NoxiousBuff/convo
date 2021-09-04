import 'package:flutter/material.dart';

class DefaultNavigation extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    throw UnimplementedError();
  }
}
