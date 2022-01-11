import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';

Widget cwAccountHeader(BuildContext context, String? photoUrl,
    String displayName, String? relationShipStatus, List<dynamic>? hashtags) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (photoUrl != null)
            userProfilePhoto(
              context,
              photoUrl,
              height: 84,
              width: 84,
              borderRadius: BorderRadius.circular(30),
            ),
          horizontalSpaceRegular,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.black),
                      ),
                      horizontalSpaceTiny,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.lightBlack)),
                        child: Text(
                          relationShipStatus ?? 'Prefer Not To Say',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
                if (hashtags != null)
                  Wrap(
                    spacing: 8,
                    direction: Axis.horizontal,
                    children: List.generate(
                      hashtags.length,
                      (index) => Text(
                        hashtags[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    ],
  );
}
