import 'package:flutter/material.dart';

class NativeAndroidRoute extends PageRouteBuilder {
  final Widget? enterPage;
  final Widget? exitPage;
  NativeAndroidRoute({this.exitPage, this.enterPage})
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
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.0,
                    end: 1.1,
                  ).animate(animation),
                  child: exitPage,
                ),
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.9,
                  ).animate(animation),
                  child: exitPage,
                ),
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.9,
                    end: 1.0,
                  ).animate(animation),
                  child: enterPage,
                ),
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.9,
                    end: 1.0,
                  ).animate(animation),
                  child: enterPage,
                ),
              ],
            );
          },
        );
}
