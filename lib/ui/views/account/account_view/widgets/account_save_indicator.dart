import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hive_flutter/hive_flutter.dart';

Widget cwAccountSaveIndicator(BuildContext context, String userId) {
  return ValueListenableBuilder<Box>(
      valueListenable: hiveApi.hiveStream(HiveApi.savedPeopleHiveBox),
      builder: (context, savedbox, child) {
        final bool alreadySaved =
            hiveApi.doesHiveContain(HiveApi.savedPeopleHiveBox, userId);
        return GestureDetector(
          onTap: () {
            alreadySaved
                ? hiveApi.deleteFromSavedPeople(userId.toString())
                : hiveApi.addToSavedPeople(userId.toString());
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.2),
                border: Border.all(
                  color: Theme.of(context).colorScheme.isDarkTheme
                      ? Theme.of(context).colorScheme.lightGrey
                      : Theme.of(context).colorScheme.darkGrey,
                )),
            child: Center(
              child: !alreadySaved
                  ? Icon(
                      FeatherIcons.bookmark,
                      color: Theme.of(context).colorScheme.black,
                    )
                  : Text(
                      'Bookmarked',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.mediumBlack),
                    ),
            ),
          ),
        );
      });
}
