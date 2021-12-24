import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

final CustomSnackbars customSnackbars = CustomSnackbars();

class CustomSnackbars {
  errorSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.redAccent,
        action: action,
        content: Text(
          title,
          style:  TextStyle(
              color: Theme.of(context).colorScheme.red, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  successSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.greenAccent,
        action: action,
        content: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.green, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  infoSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.blueAccent,
        action: action,
        content: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.blue, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

}
