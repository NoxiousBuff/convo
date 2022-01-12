import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/account/edit_account/change_bio/change_bio_view.dart';
import 'package:hint/ui/views/account/edit_account/change_displayname/change_displayname_view.dart';
import 'package:hint/ui/views/account/edit_account/change_dob/change_dob_view.dart';
import 'package:hint/ui/views/account/edit_account/change_hashtags/change_hashtags_view.dart';
import 'package:hint/ui/views/account/edit_account/change_interest/change_interest_view.dart';
import 'package:hint/ui/views/account/edit_account/change_username/change_username_view.dart';
import 'package:hint/ui/views/account/edit_account/widgets/change_gender_modal.dart';
import 'package:hint/ui/views/account/edit_account/widgets/change_relationship_status_model.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';

import 'edit_account_viewmodel.dart';

class EditAccountView extends StatelessWidget {
  EditAccountView({Key? key}) : super(key: key);
  final log = getLogger('EditAccountView');
  final liverUserUid = hiveApi.getUserData(FireUserField.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditAccountViewModel>.reactive(
      onModelReady: (model) {
        model.birthDateFormatter();
      },
      viewModelBuilder: () => EditAccountViewModel(),
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
          builder: (context, box, child) {
            final profileKey = box.get(FireUserField.photoUrl);
            final dob = box.get(FireUserField.dob);
            final isDobNull = dob == null;
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
              appBar: cwAuthAppBar(context,
                  title: 'Edit Profile',
                  onPressed: () => Navigator.pop(context)),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  verticalSpaceRegular,
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
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
                                  onTap: () => model.pickImage(context)),
                              cwEADetailsTile(
                                context,
                                'Cancel',
                                titleColor: Colors.red,
                                onTap: () => Navigator.pop(context),
                              ),
                              bottomPadding(context)
                            ],
                          ),
                        );
                      },
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                UserProfilePhoto(
                                  profileKey,
                                  height: 104,
                                  width: 104,
                                  borderRadius: BorderRadius.circular(38),
                                ),
                                !model.isBusy
                                    ? shrinkBox
                                    : const SizedBox(
                                        height: 104,
                                        width: 104,
                                        child: CupertinoActivityIndicator())
                              ],
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Change profile photo',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceLarge,
                  cwEADetailsTile(context, 'Display Name',
                      subtitle: box.get(FireUserField.displayName,
                          defaultValue: 'Select Your gender'), onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeDisplayNameView());
                  }),
                  cwEADetailsTile(context, 'UserName',
                      subtitle: box.get(FireUserField.username,
                          defaultValue: 'Select Your gender'), onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeUserNameView());
                  }),
                  cwEADetailsTile(context, 'Bio', subtitle: 'Update Your Bio',
                      onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeBioView());
                  }),
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADetailsTile(
                    context,
                    'Gender',
                    subtitle: box.get(FireUserField.gender,
                        defaultValue: 'Select Your gender'),
                    onTap: () => showChangeGenderModal(context, model),
                  ),
                  cwEADetailsTile(
                    context,
                    'RelationShip Status',
                    subtitle: box.get(FireUserField.romanticStatus,
                        defaultValue: 'What\'s Your Status'),
                    onTap: () =>
                        showChangeRelationshipStatusModal(context, model),
                  ),
                  const Divider(),
                  verticalSpaceRegular,
                  Builder(
                    builder: (context) {
                      return cwEADetailsTile(
                          context, 'Date of Birth'.toString(),
                          subtitle: !isDobNull
                              ? model.formattedBirthDate
                              : 'Pick Your DOB', onTap: () {
                        navService.cupertinoPageRoute(
                            context, const ChangeDobView());
                      });
                    },
                  ),
                  cwEADetailsTile(context, 'Hashtags',
                      subtitle: 'Find Your HashTags', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeHashtagsView());
                  }),
                  cwEADetailsTile(context, 'Interests',
                      subtitle: 'Choose Your Interest', onTap: () {
                    navService.cupertinoPageRoute(
                        context, const ChangeInterestView());
                  }),
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Personal Information'),
                  verticalSpaceRegular,
                  cwEADetailsTile(context, 'Email',
                      subtitle: box.get(FireUserField.email,
                          defaultValue: 'Some error in fetching value.'),
                      showTrailingIcon: false),
                  verticalSpaceLarge,
                  bottomPadding(context),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
