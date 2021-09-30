import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final NavService navService = NavService();

class NavService {
  Future<void> materialPageRoute(BuildContext context, Widget page,
      {bool rootNavigator = false,
      RouteSettings? routeSettings,
      bool maintainState = true,
      bool fullscreenDialog = false}) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .push(MaterialPageRoute(
      builder: (context) => page,
      settings: routeSettings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  Future<void> cupertinoPageRoute(BuildContext context, Widget page,
      {bool rootNavigator = false,
      RouteSettings? routeSettings,
      bool maintainState = true,
      bool fullscreenDialog = false}) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .push(CupertinoPageRoute(
      builder: (context) => page,
      settings: routeSettings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    ));
  }
}
