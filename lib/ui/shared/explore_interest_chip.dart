import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

Widget exploreInterestChip(String interestIitle,
    {Color? backgroundChipColor, Color? textColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: GestureDetector(
      onTap: () {},
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: backgroundChipColor ?? AppColors.lightGrey,
        label: Text(
          interestIitle,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor ?? Colors.black),
        ),
      ),
    ),
  );
}
