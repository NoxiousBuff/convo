import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/edit_account_viewmodel.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

Future<void> showChangeGenderModal(
    BuildContext context, EditAccountViewModel model) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                cwEADescriptionTitle(
                  context,
                  'Select Your gender',
                ),
              ],
            ),
            cwEADetailsTile(context, 'Male', onTap: () {
              model.updateUserProperty(context, FireUserField.gender, 'Male', useSetBusy: false);
              Navigator.pop(context);
            }),
            cwEADetailsTile(context, 'Female', onTap: () {
              model.updateUserProperty(
                  context, FireUserField.gender, 'Female', useSetBusy: false);
                  Navigator.pop(context);
            }),
            cwEADetailsTile(context, 'TransGender', onTap: () {
              model.updateUserProperty(
                  context, FireUserField.gender, 'TransGender', useSetBusy: false);
                  Navigator.pop(context);
            }),
            cwEADetailsTile(context, 'Prefer Not To Say', onTap: () {
              model.updateUserProperty(
                  context, FireUserField.gender, 'Prefer Not To Say', useSetBusy: false);
                  Navigator.pop(context);
            }),
            cwEADetailsTile(context, 'Cancel', titleColor: Colors.red,
                onTap: () {
              Navigator.pop(context);
            }),
            bottomPadding(context)
          ],
        ),
      );
    },
  );
}
