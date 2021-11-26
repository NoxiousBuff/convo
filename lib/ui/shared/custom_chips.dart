import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

final CustomChips customChips = CustomChips();

class CustomChips {
  errorChip(String title) {
    return Chip(
      label: Text(title),
      labelStyle: const TextStyle(
          color: AppColors.red, fontSize: 18, fontWeight: FontWeight.w700),
      backgroundColor: AppColors.redAccent.withAlpha(100),
    );
  }

  successChip(String title) {
    return Chip(
      label: Text(title),
      labelStyle: const TextStyle(
          color: AppColors.blue, fontSize: 18, fontWeight: FontWeight.w700),
      backgroundColor: AppColors.blueAccent.withAlpha(100),
    );
  }

  progressChip({int? size, EdgeInsets? padding}) {
    return Chip(
      backgroundColor: AppColors.blueAccent.withAlpha(100),
      padding: const EdgeInsets.symmetric(vertical: 8),
      label: const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
        ),
      ),
    );
  }
}
