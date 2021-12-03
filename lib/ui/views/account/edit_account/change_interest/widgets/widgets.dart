import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

import '../change_interest_viewmodel.dart';

Widget cwCIInterestTopicPicker(
    String title, List<String> interestList, ChangeInterestViewModel model,
    {Color? color, Icon? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpaceRegular,
      Row(
        children: [
          Container(
            child: icon ??
                const Icon(
                  FeatherIcons.plus,
                  color: LightAppColors.onPrimary,
                ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color ?? AppColors.blue),
          ),
          horizontalSpaceRegular,
          Text(
            title,
            style: const TextStyle(
                color: LightAppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      verticalSpaceRegular,
      Wrap(
        spacing: 8,
        children: interestList
            .map(
              (label) => cwCIInterestChip(label, model),
            )
            .toList(),
      )
    ],
  );
}

Widget cwCIInterestChip(String label, ChangeInterestViewModel model) {
  bool isSelected = model.userInterests.contains(label);
  return GestureDetector(
    onTap: () {
      if (!isSelected) {
        model.userInterests.add(label);
        log('added $label');
      } else {
        model.userInterests.remove(label);
        log('remove $label');
      }
      model.notifyListeners();
    },
    child: Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      backgroundColor: isSelected ? AppColors.blue : AppColors.grey,
      label: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? LightAppColors.onPrimary : Colors.black),
      ),
    ),
  );
}