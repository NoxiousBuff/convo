import 'package:flutter/material.dart';

class VerticalEnterExitRoute extends PageRouteBuilder {
  final Widget? enterPage;
  final Widget? exitPage;
  VerticalEnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(0.0, -1.0),
                  ).animate(animation),
                  child: exitPage,
                ),
                SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                )
              ],
            );
          },
        );
}
