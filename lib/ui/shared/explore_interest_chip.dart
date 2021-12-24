import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

Widget exploreInterestChip(BuildContext context, String interestIitle,
    {Color? backgroundChipColor, Color? textColor, void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Chip(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.scaffoldColor,
              width: 0,
              style: BorderStyle.none),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: backgroundChipColor ?? Theme.of(context).colorScheme.lightGrey,
        label: Text(
          interestIitle,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor ?? Theme.of(context).colorScheme.black),
        ),
      ),
    ),
  );
}
