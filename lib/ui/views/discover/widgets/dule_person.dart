import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/views/discover/discover_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final currentUserId = hiveApi.getUserDataWithHive(FireUserField.id);
  return fireUser.id == currentUserId
      ? const SizedBox.shrink()
      : InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            chatService.startDuleConversation(context, fireUser);
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
                          SizedBox(
                              width: 56,
                              height: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  fireUser.photoUrl,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fireUser.displayName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(fireUser.country ?? '',
                                      style:
                                          TextStyle(color: Colors.grey[500])),
                                ]),
                          )
                        ]),
                      ),
                      ValueListenableBuilder<Box>(
                          valueListenable:
                              hiveApi.hiveStream(HiveApi.savedPeopleHiveBox),
                          builder: (context, box, child) {
                            final bool alreadySaved = hiveApi.doesHiveContain(
                                HiveApi.savedPeopleHiveBox, fireUser.id);
                            return GestureDetector(
                              onTap: () {
                                alreadySaved
                                    ? model.deleteFromSavedPeople(fireUser.id)
                                    : model.addToSavedPeople(fireUser.id);
                              },
                              child: AnimatedContainer(
                                height: 35,
                                padding: const EdgeInsets.all(5),
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    )),
                                child: Center(
                                  child: !alreadySaved
                                      ? Icon(
                                          FeatherIcons.bookmark,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        )
                                      : Text(
                                          'Saved',
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                ),
                              ),
                            );
                          }),
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
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (commonInterests.length > 6)
                          Text(
                            '+ ${commonInterests.length - 6} more',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 12),
                          )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
}
