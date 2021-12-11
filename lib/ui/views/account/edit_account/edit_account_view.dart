import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/constants/relationship_status_list.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/change_bio/change_bio_view.dart';
import 'package:hint/ui/views/account/edit_account/change_displayname/change_displayname_view.dart';
import 'package:hint/ui/views/account/edit_account/change_dob/change_dob_view.dart';
import 'package:hint/ui/views/account/edit_account/change_hashtags/change_hashtags_view.dart';
import 'package:hint/ui/views/account/edit_account/change_interest/change_interest_view.dart';
import 'package:hint/ui/views/account/edit_account/change_username/change_username_view.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
      onModelReady: (model) {
        model.birthDateFormatter();
      },
      viewModelBuilder: () => EditAccountViewModel(),
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
          builder: (context, box, child) {
            final profileKey = box.get(FireUserField.photoUrl);
            final dob = box.get(FireUserField.dob);
            final isDobNull = dob == null;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: cwAuthAppBar(context, title: 'Edit Profile'),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  verticalSpaceRegular,
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        topRadius: const Radius.circular(32),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cwEADescriptionTitle(
                                          context, 'Change Your Photo'),
                                    ],
                                  ),
                                  cwEADetailsTile(context, 'New Profile Photo',
                                      onTap: () {
                                    model.pickImage().then((value) async {
                                      Navigator.pop(context);
                                      final file = value;
                                      if (file != null) {
                                        final String? downloadUrl = await model
                                            .uploadFile(file.path, context);
                                        model.updateUserProperty(
                                            context,
                                            FireUserField.photoUrl,
                                            downloadUrl);
                                        model.setBusy(false);
                                      }
                                    });
                                  }),
                                  cwEADetailsTile(context, 'Cancel',
                                      titleColor: Colors.red, onTap: () {
                                    Navigator.pop(context);
                                  }),
                                  bottomPadding(context)
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            model.isBusy
                                ? const SizedBox(
                                    height: 104,
                                    width: 104,
                                    child: CupertinoActivityIndicator())
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(38),
                                    child: CachedNetworkImage(
                                      imageUrl: profileKey,
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
                          children: const [
                            Text(
                              'Change profile photo',
                              style: TextStyle(color: AppColors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceLarge,
                  cwEADetailsTile(context, 'Display Name',
                      descriptionTitle: box.get(FireUserField.displayName,
                          defaultValue: 'Select Your gender'), onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeDisplayNameView());
                  }),
                  cwEADetailsTile(context, 'UserName',
                      descriptionTitle: box.get(FireUserField.username,
                          defaultValue: 'Select Your gender'), onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeUserNameView());
                  }),
                  cwEADetailsTile(context, 'Bio',
                      descriptionTitle: 'Update Your Bio', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeBioView());
                  }),
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADetailsTile(
                    context,
                    'Gender',
                    descriptionTitle: box.get(FireUserField.gender,
                        defaultValue: 'Select Your gender'),
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        topRadius: const Radius.circular(32),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cwEADescriptionTitle(
                                        context,
                                        'Select Your gender',
                                      ),
                                    ],
                                  ),
                                  cwEADetailsTile(context, 'Male', onTap: () {
                                    model.updateUserProperty(
                                        context, FireUserField.gender, 'Male');
                                  }),
                                  cwEADetailsTile(context, 'Female', onTap: () {
                                    model.updateUserProperty(context,
                                        FireUserField.gender, 'Female');
                                  }),
                                  cwEADetailsTile(context, 'TransGender',
                                      onTap: () {
                                    model.updateUserProperty(context,
                                        FireUserField.gender, 'TransGender');
                                  }),
                                  cwEADetailsTile(context, 'Prefer Not To Say',
                                      onTap: () {
                                    model.updateUserProperty(
                                        context,
                                        FireUserField.gender,
                                        'Prefer Not To Say');
                                  }),
                                  cwEADetailsTile(context, 'Cancel',
                                      titleColor: Colors.red, onTap: () {
                                    Navigator.pop(context);
                                  }),
                                  bottomPadding(context)
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  cwEADetailsTile(context, 'RelationShip Status',
                      descriptionTitle: box.get(FireUserField.romanticStatus,
                          defaultValue: 'What\'s Your Status'), onTap: () {
                    showCupertinoModalBottomSheet(
                      topRadius: const Radius.circular(32),
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
                                        context, relationshipStatusList[i],
                                        onTap: () {
                                      model.updateUserProperty(
                                          context,
                                          FireUserField.romanticStatus,
                                          relationshipStatusList[i]);
                                    });
                                  },
                                          childCount:
                                              relationshipStatusList.length)),
                                  SliverToBoxAdapter(
                                    child: cwEADetailsTile(context, 'Cancel',
                                        titleColor: Colors.red, onTap: () {
                                      Navigator.pop(context);
                                    }),
                                  ),
                                  SliverToBoxAdapter(
                                      child: bottomPadding(context)),
                                ],
                              )),
                        );
                      },
                    );
                  }),
                  const Divider(),
                  verticalSpaceRegular,
                  // cwEADescriptionTitle(context, 'Details'),
                  cwEADetailsTile(context, 'Date of Birth'.toString(),
                      descriptionTitle: !isDobNull
                          ? model.formattedBirthDate
                          : 'Pick Your DOB', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeDobView());
                  }),
                  cwEADetailsTile(context, 'Hashtags',
                      descriptionTitle: 'Find Your HashTags', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeHashtagsView());
                  }),
                  cwEADetailsTile(context, 'Interests',
                      descriptionTitle: 'Choose Your Interest', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeInterestView());
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
