import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

final CustomSnackbars customSnackbars = CustomSnackbars();

class CustomSnackbars {
  errorSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.redAccent,
        action: action,
        content: Text(
          title,
          style: const TextStyle(
              color: AppColors.red, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  successSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.greenAccent,
        action: action,
        content: Text(
          title,
          style: const TextStyle(
              color: AppColors.green, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  infoSnackbar(BuildContext context, {required String title, SnackBarAction? action}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.blueAccent,
        action: action,
        content: Text(
          title,
          style: const TextStyle(
              color: AppColors.blue, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

}
