import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

Widget exploreInterestChip(String interestIitle,
    {Color? backgroundChipColor, Color? textColor, void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: backgroundChipColor ?? AppColors.lightGrey,
        label: Text(
          interestIitle,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor ?? AppColors.black),
        ),
      ),
    ),
  );
}
