import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

import '../change_interest_viewmodel.dart';

Widget cwCIInterestTopicPicker(BuildContext context, String title,
    List<String> interestList, ChangeInterestViewModel model,
    {Color? color, Icon? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpaceRegular,
      Row(
        children: [
          Container(
            child: icon ??
               Icon(
                  FeatherIcons.plus,
                  color: Theme.of(context).colorScheme.white,
                ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color ?? Theme.of(context).colorScheme.blue),
          ),
          horizontalSpaceRegular,
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.purple,
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
              (label) => CWCIInterestChip(label, model),
            )
            .toList(),
      )
    ],
  );
}

// Widget cwCIInterestChip(String label, ChangeInterestViewModel model) {
//   bool isSelected = model.userSelectedInterests.contains(label);
//   return GestureDetector(
//     onTap: () {
//       if (!isSelected) {
//         model.userSelectedInterests.add(label);
//         log('added $label');
//       } else {
//         model.userSelectedInterests.remove(label);
//         log('remove $label');
//       }
//       model.isEdited ? () {} : model.updateIsEdited(true);
//       model.notifyListeners();
//     },
//     child: Chip(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       backgroundColor: isSelected ? Theme.of(context).colorScheme.blue : Theme.of(context).colorScheme.grey,
//       label: Text(
//         label,
//         style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//             color: isSelected
//                 ? Theme.of(context).colorScheme.white
//                 : Theme.of(context).colorScheme.black),
//       ),
//     ),
//   );
// }

class CWCIInterestChip extends StatelessWidget {
  const CWCIInterestChip(this.label, this.model, {Key? key}) : super(key: key);
  final String label;
  final ChangeInterestViewModel model;
  @override
  Widget build(BuildContext context) {
    bool isSelected = model.userSelectedInterests.contains(label);
  return GestureDetector(
    onTap: () {
      if (!isSelected) {
        model.userSelectedInterests.add(label);
        log('added $label');
      } else {
        model.userSelectedInterests.remove(label);
        log('remove $label');
      }
      model.isEdited ? () {} : model.updateIsEdited(true);
      model.notifyListeners();
    },
    child: Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      backgroundColor: isSelected ? Theme.of(context).colorScheme.blue : Theme.of(context).colorScheme.grey,
      label: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected
                ? Theme.of(context).colorScheme.white
                : Theme.of(context).colorScheme.black),
      ),
    ),
  );
  }
}
