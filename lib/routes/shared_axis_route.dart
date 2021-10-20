import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute({Widget? page, SharedAxisTransitionType? transitionType})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
          ) =>
              page!,
          transitionsBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
            Widget child,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation as Animation<double>,
              secondaryAnimation: secondaryAnimation as Animation<double>,
              transitionType: transitionType!,
              child: child,
            );
          },
        );
}