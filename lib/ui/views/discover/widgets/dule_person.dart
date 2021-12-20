import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_button.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_save_indicator.dart';
import 'package:hint/ui/views/discover/discover_viewmodel.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';

import 'dule_person_dialog.dart';

Widget dulePerson(
    BuildContext context, DiscoverViewModel model, FireUser fireUser,
    {Function? onTap}) {
  final lists = [
    model.usersInterests,
    fireUser.interests,
  ];
  final commonInterests =
      lists.fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()));
  final int interestLength = commonInterests.length;
  final currentUserId = hiveApi.getUserData(FireUserField.id);
  return fireUser.id == currentUserId
      ? const SizedBox.shrink()
      : InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () {
          showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  context: context,
                  builder: (context) {
                    return DulePersonDialog(fireUser: fireUser);
                  });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(children: [
                        userProfilePhoto(context, fireUser.photoUrl),
                        horizontalSpaceSmall,
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fireUser.username,
                                    style:  TextStyle(
                                        color: AppColors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(fireUser.country ?? '',
                                    style:
                                        const TextStyle(color: AppColors.mediumBlack)),
                              ]),
                        )
                      ]),
                    ),
                    cwAccountSaveIndicator(context, fireUser.id),
                    horizontalSpaceSmall,
                    cwAccountIconButton(context, onTap: ()=> navService.materialPageRoute(context, WriteLetterView(fireUser: fireUser)))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (interestLength > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          runSpacing: 8,
                          children: [
                            if (interestLength >= 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        AppColors.blueAccent.withAlpha(100)),
                                child: Text(
                                  commonInterests.first.toString(),
                                  style: const TextStyle(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (interestLength >= 2)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        AppColors.greenAccent.withAlpha(100)),
                                child: Text(
                                  commonInterests.elementAt(2).toString(),
                                  style: const TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (interestLength >= 3)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        AppColors.yellowAccent.withAlpha(80)),
                                child: Text(
                                  commonInterests.elementAt(3).toString(),
                                  style: const TextStyle(
                                      color: AppColors.yellow,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (interestLength >= 4)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.purpleAccent
                                        .withAlpha(100)),
                                child: Text(
                                  commonInterests.elementAt(4).toString(),
                                  style: const TextStyle(
                                      color: AppColors.purple,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (interestLength >= 5)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        AppColors.redAccent.withAlpha(100)),
                                child: Text(
                                  commonInterests.elementAt(5).toString(),
                                  style: const TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (interestLength >= 6)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        AppColors.lightGrey.withAlpha(100)),
                                child: Text(
                                  commonInterests.elementAt(6).toString(),
                                  style: const TextStyle(
                                      color: AppColors.mediumBlack,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (commonInterests.length > 6)
                        Text(
                          '+ ${commonInterests.length - 6} more',
                          style: const TextStyle(
                              color: AppColors.mediumBlack, fontSize: 12),
                        )
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}
