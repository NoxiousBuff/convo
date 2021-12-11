import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.fireUser}) : super(key: key);

  final FireUser fireUser;

  static const String id = '/ProfileView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => ValueListenableBuilder<Box>(
        valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FeatherIcons.moreVertical),
                  color: Colors.black,
                  iconSize: 24,
                ),
                horizontalSpaceSmall
              ],
              elevation: 0.0,
              toolbarHeight: 60,
              title: Text(
                fireUser.username,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.scrolledUnder)
                    ? Colors.grey.shade50
                    : Colors.white;
              }),
              leading: IconButton(
                color: Colors.black54,
                icon: const Icon(FeatherIcons.arrowLeft),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                verticalSpaceRegular,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: fireUser.photoUrl,
                        height: 84,
                        width: 84,
                        fit: BoxFit.cover,
                      ),
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
                                      fireUser.displayName,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    horizontalSpaceTiny,
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                                      decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.darkGrey)),
                                  child: Text(
                                fireUser.romanticStatus!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                                    )
                                  ],
                                ),
                              ),
                          verticalSpaceTiny,
                          Wrap(
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
                        ],
                      ),
                    )
                  ],
                ),
                verticalSpaceLarge,
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14.2),
                            onTap: () {
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.2),
                            border: Border.all(color: AppColors.darkGrey)),
                        child: const Icon(FeatherIcons.send)),
                    horizontalSpaceSmall,
                    ValueListenableBuilder<Box>(
                        valueListenable:
                            hiveApi.hiveStream(HiveApi.savedPeopleHiveBox),
                        builder: (context, savedbox, child) {
                          final bool alreadySaved = hiveApi.doesHiveContain(
                              HiveApi.savedPeopleHiveBox, fireUser.id);
                          return GestureDetector(
                            onTap: () {
                              alreadySaved
                                  ? hiveApi.deleteFromSavedPeople(
                                      fireUser.id.toString())
                                  : hiveApi
                                      .addToSavedPeople(fireUser.id.toString());
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.2),
                                  border:
                                      Border.all(color: AppColors.darkGrey)),
                              child: Center(
                                child: !alreadySaved
                                    ? const Icon(
                                        FeatherIcons.bookmark,
                                        color: Colors.black,
                                      )
                                    : Text(
                                        'Bookmarked',
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                verticalSpaceLarge,
                Text(
                  fireUser.bio,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                verticalSpaceMedium,
                SizedBox(
                  child: Wrap(
                    spacing: 4,
                    children: List.generate(
                      fireUser.interests.length,
                      (index) => exploreInterestChip(fireUser.interests[index]),
                    ),
                  ),
                ),
                verticalSpaceLarge,
                bottomPadding(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
