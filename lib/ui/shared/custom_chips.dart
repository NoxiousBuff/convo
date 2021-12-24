import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

final CustomChips customChips = CustomChips();

class CustomChips {
  errorChip(BuildContext context, String title) {
    return Chip(
      label: Text(title),
      labelStyle:  TextStyle(
          color: Theme.of(context).colorScheme.red, fontSize: 18, fontWeight: FontWeight.w700),
      backgroundColor: Theme.of(context).colorScheme.redAccent.withAlpha(100),
    );
  }

  successChip(BuildContext context, String title) {
    return Chip(
      label: Text(title),
      labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.blue, fontSize: 18, fontWeight: FontWeight.w700),
      backgroundColor: Theme.of(context).colorScheme.blueAccent.withAlpha(100),
    );
  }

  progressChip(BuildContext context, {int? size, EdgeInsets? padding}) {
    return Chip(
      backgroundColor: Theme.of(context).colorScheme.blueAccent.withAlpha(100),
      padding: const EdgeInsets.symmetric(vertical: 8),
      label: SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.blue),
        ),
      ),
    );
  }
}
