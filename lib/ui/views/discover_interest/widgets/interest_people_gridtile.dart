import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/discover/widgets/dule_person_dialog.dart';

Widget interestedPeopleGridTile(BuildContext context, FireUser fireUser) {
  final usersInterests =
      hiveApi.getUserData(FireUserField.interests) as List<dynamic>;
  final lists = [
    usersInterests,
    fireUser.interests,
  ];
  final commonInterests =
      lists.fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()));

  final compatiblePercentage =
      commonInterests.length / usersInterests.length * 100;

  return Material(
    elevation: 00,
    borderRadius: BorderRadius.circular(32),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
            context: context,
            builder: (context) {
              return DulePersonDialog(fireUser: fireUser);
            });
      },
      borderRadius: BorderRadius.circular(32),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userProfilePhoto(
              context,
              fireUser.photoUrl,
              height: screenWidthPercentage(context, percentage: 0.2),
              width: screenWidthPercentage(context, percentage: 0.2),
              borderRadius: BorderRadius.circular(32),
            ),
            verticalSpaceRegular,
            Container(
              alignment: Alignment.center,
              width: screenWidthPercentage(context, percentage: 0.4),
              child: Text(
                fireUser.username,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            verticalSpaceTiny,
            SizedBox(
              child: Text(
                '${compatiblePercentage.toInt().toString()}% compatible',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.mediumBlack),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
