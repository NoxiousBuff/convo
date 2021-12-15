import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DulePersonDialog extends StatelessWidget {
  const DulePersonDialog({ Key? key, required this.fireUser }) : super(key: key);

  final FireUser fireUser;

  @override
  Widget build(BuildContext context) {
    return Material(
    borderRadius: BorderRadius.circular(32),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpaceMedium,
          ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Container(
                height: screenWidthPercentage(context, percentage: 0.4),
                width: screenWidthPercentage(context, percentage: 0.4),
                child: CachedNetworkImage(
                  imageUrl: fireUser.photoUrl,
                  fit: BoxFit.cover,
                ),
                color: Colors.indigo.shade200.withAlpha(50),
              )),
          verticalSpaceRegular,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  fireUser.username,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
                horizontalSpaceTiny,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkGrey)),
                  child: Text(
                    fireUser.romanticStatus ?? '',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          verticalSpaceRegular,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            direction: Axis.horizontal,
            children: List.generate(
              fireUser.hashTags.length,
              (index) => Text(
                fireUser.hashTags[index],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          verticalSpaceLarge,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    chatService.startDuleConversation(context, fireUser);
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(14.2)),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              InkWell(
                borderRadius: BorderRadius.circular(14.2),
                onTap: () {
                  navService.materialPageRoute(context, WriteLetterView(fireUser: fireUser));
                },
                child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.2),
                        border: Border.all(color: AppColors.darkGrey)),
                    child: const Icon(FeatherIcons.send)),
              ),
              horizontalSpaceSmall,
              ValueListenableBuilder<Box>(
                  valueListenable:
                      hiveApi.hiveStream(HiveApi.savedPeopleHiveBox),
                  builder: (context, savedbox, child) {
                    final bool alreadySaved = hiveApi.doesHiveContain(
                        HiveApi.savedPeopleHiveBox, fireUser.id);
                    return InkWell(
                      borderRadius: BorderRadius.circular(14.2),
                      onTap: () {
                        alreadySaved
                            ? hiveApi
                                .deleteFromSavedPeople(fireUser.id.toString())
                            : hiveApi.addToSavedPeople(fireUser.id.toString());
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.2),
                            border: Border.all(color: AppColors.darkGrey)),
                        child: Center(
                          child: !alreadySaved
                              ? const Icon(
                                  FeatherIcons.bookmark,
                                  color: Colors.black,
                                )
                              : Text(
                                  'Bookmarked',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
          verticalSpaceLarge,
          bottomPadding(context)
        ],
      ),
    ),
  );
  }
}
