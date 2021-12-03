import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/edit_account_view.dart';
import 'package:hint/ui/views/contacts/contacts_view.dart';
import 'package:hint/ui/views/distant_view/distant_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'account_viewmodel.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  static const String id = '/AccountView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
      viewModelBuilder: () => AccountViewModel(),
      builder: (context, model, child) => ValueListenableBuilder<Box>(
        valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
        builder: (context, model, child) {
          return ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
            builder: (context, box, child) {
              String bioKey = FireUserField.bio;
              String profileKey = FireUserField.photoUrl;
              String usernameKey = FireUserField.username;
              String hashTagsKey = FireUserField.hashTags;
              String interestKey = FireUserField.interests;
              String displayNameKey = FireUserField.displayName;
              String relationshipKey = FireUserField.romanticStatus;

              return Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  actions: [
                    IconButton(
                      onPressed: () => navService.cupertinoPageRoute(
                          context, const DistantView()),
                      icon: const Icon(FeatherIcons.settings),
                      color: Colors.black,
                      iconSize: 24,
                    ),
                    IconButton(
                      onPressed: () {
                        navService.cupertinoPageRoute(
                            context, const ContactsView());
                      },
                      icon: const Icon(FeatherIcons.shield),
                      color: Colors.black,
                      iconSize: 24,
                    ),
                    horizontalSpaceSmall
                  ],
                  elevation: 0.0,
                  toolbarHeight: 60,
                  title: Text(
                    box.get(usernameKey),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.scrolledUnder)
                        ? Colors.grey.shade50
                        : Colors.white;
                  }),
                  leadingWidth: 0,
                ),
                body: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    verticalSpaceRegular,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ExtendedImage(
                            image: NetworkImage(box.get(profileKey)),
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
                                      box.get(displayNameKey),
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
                                box.get(relationshipKey),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                                    )
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                direction: Axis.horizontal,
                                children: List.generate(
                                  box.get(hashTagsKey).length,
                                  (index) => Text(
                                    box.get(hashTagsKey)[index],
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
                              navService.cupertinoPageRoute(context, EditAccountView());
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.2),
                                  border: Border.all(color: AppColors.darkGrey)),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                    Text(
                      box.get(bioKey),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    verticalSpaceMedium,
                    SizedBox(
                      // margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Wrap(
                        spacing: 4,
                        children: List.generate(
                          box.get(interestKey).length,
                          (index) =>
                              exploreInterestChip(box.get(interestKey)[index]),
                        ),
                      ),
                    ),
                    verticalSpaceLarge,
                    bottomPadding(context),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
