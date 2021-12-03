import 'package:extended_image/extended_image.dart';
import 'package:hint/constants/relationship_status_list.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/change_hashtags/change_hashtags_view.dart';
import 'package:hint/ui/views/account/edit_account/change_interest/change_interest_view.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';

import 'edit_account_viewmodel.dart';

class EditAccountView extends StatelessWidget {
  EditAccountView({Key? key}) : super(key: key);
  final log = getLogger('EditAccountView');
  final liverUserUid = hiveApi.getUserDataWithHive(FireUserField.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditAccountViewModel>.reactive(
      viewModelBuilder: () => EditAccountViewModel(),
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
          builder: (context, box, child) {
            final profileKey = box.get(FireUserField.photoUrl);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: cwAuthAppBar(context, title: 'Edit Profile'),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(38),
                        child: ExtendedImage(
                          image: NetworkImage(profileKey),
                          height: 104,
                          width: 104,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Material(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cwEADescriptionTitle(
                                      context, 'Change Your Photo'),
                                  cwEADetailsTile(context, 'New Profile Photo'),
                                  cwEADetailsTile(context, 'Remove Profile Photo', titleColor: Colors.red),
                                  bottomPadding(context)
                                ],
                              ),
                            ),
                          );
                      },
                    );
                        },
                        child: const Text(
                          'Change profile photo',
                          style: TextStyle(color: AppColors.blue),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Display Name'),
                  verticalSpaceTiny,
                  cwEATextField(context, model.displayNameTech, 'Display Name'),
                  cwEADescriptionTitle(context, 'User Name'),
                  verticalSpaceTiny,
                  cwEATextField(context, model.userNameTech, 'User Name'),
                  cwEADescriptionTitle(context, 'Bio'),
                  verticalSpaceTiny,
                  cwEATextField(context, model.bioTech, 'Bio',
                      maxLength: 250, expands: true),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Details'),
                  cwEADetailsTile(context, 'Date of Birth',
                      descriptionTitle: 'Pick Your DOB', onTap: () {
                        showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Material(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white,
                            child: SizedBox(
                              height: screenHeightPercentage(context, percentage: 50),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: CupertinoDatePicker(onDateTimeChanged: (dateTime) {
                            
                                })
                              ),
                            ),
                          );
                        },
                      );
                      // showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(0), lastDate: DateTime.now());
                      }),
                  cwEADetailsTile(
                    context,
                    'Gender',
                    descriptionTitle: box.get(FireUserField.gender, defaultValue: 'Select Your gender'),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Material(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cwEADescriptionTitle(
                                      context, 'Select Your gender'),
                                  cwEADetailsTile(context, 'Male'),
                                  cwEADetailsTile(context, 'Female'),
                                  cwEADetailsTile(context, 'TransGender'),
                                  cwEADetailsTile(context, 'Prefer Not To Say'),
                                  cwEADetailsTile(context,
                                      'Didn\'t Find Your Gender. Reach Out To Us.'),
                                  bottomPadding(context)
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  cwEADetailsTile(context, 'Hashtags',
                      descriptionTitle: 'Find Your HashTags', onTap: () {
                        navService.cupertinoPageRoute(context, const ChangeHashtagsView());
                      }),
                  cwEADetailsTile(context, 'Interests',
                      descriptionTitle: 'Choose Your Interest', onTap: () {
                        navService.cupertinoPageRoute(context, const ChangeInterestView());
                      }),
                  cwEADetailsTile(context, 'RelationShip Status',
                      descriptionTitle: box.get(FireUserField.romanticStatus, defaultValue: 'What\'s Your Status'), onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return Material(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: CustomScrollView(
                                shrinkWrap: true,
                                slivers: [
                                  SliverToBoxAdapter(
                                      child: cwEADescriptionTitle(
                                          context, 'What\'s Your Status')),
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, i) {
                                    return cwEADetailsTile(
                                        context, relationshipStatusList[i]);
                                  },
                                          childCount:
                                              relationshipStatusList.length)),
                                  SliverToBoxAdapter(
                                      child: bottomPadding(context)),
                                ],
                              )),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
