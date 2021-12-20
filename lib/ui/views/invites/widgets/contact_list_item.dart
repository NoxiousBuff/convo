import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/contact_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/invites/invites_viewmodel.dart';

Widget contactListItem(
  BuildContext context,
  InvitesViewModel model,
  ContactModel contact,
) {
  var number = contact.phoneNumber;
  var code = contact.countryPhoneCode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    child: Row(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            contact.displayName[0],
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                fontSize: 20),
          ),
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        horizontalSpaceRegular,
        Expanded(
          child: cwEADetailsTile(
            context,
            contact.displayName,
            showTrailingIcon: false,
            subtitle: '$code $number',
          ),
        ),
        InkWell(
          onTap: () => model.invitePeople(),
          borderRadius: BorderRadius.circular(14.2),
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(14.2),
            ),
            child: const Center(
              child: Text(
                'Invite',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
