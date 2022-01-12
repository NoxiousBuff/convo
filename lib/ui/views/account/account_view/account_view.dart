import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_appbar.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_bio.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_button.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_header.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_interests.dart';
import 'package:hint/ui/views/account/edit_account/edit_account_view.dart';
import 'package:hint/ui/views/settings/settings_view.dart';
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
        valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
        builder: (context, model, child) {
          return ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, box, child) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
                appBar: cwAccountAppBar(
                  context,
                  box.get(FireUserField.username),
                  actions: [
                    IconButton(
                      onPressed: () => navService.materialPageRoute(
                          context, const SettingsView()),
                      icon: const Icon(FeatherIcons.settings),
                      color: Theme.of(context).colorScheme.black,
                      iconSize: 24,
                    ),
                    horizontalSpaceSmall
                  ],
                  showLeadingIcon: false,
                ),
                body: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    verticalSpaceRegular,
                    cwAccountHeader(
                      context,
                      box.get(FireUserField.photoUrl,
                          defaultValue: FirestoreApi.kDefaultPhotoUrl),
                      box.get(
                        FireUserField.displayName,
                      ),
                      box.get(FireUserField.romanticStatus,
                          defaultValue: 'Prefer Not To Say'),
                      box.get(FireUserField.hashTags,
                          defaultValue: ['#friendly', '#new', '#available']),
                    ),
                    verticalSpaceLarge,
                    Row(
                      children: [
                        Expanded(
                          child: cwAccountButton(
                            context,
                            'Edit Profile',
                            onTap: () => navService.materialPageRoute(
                                context, EditAccountView()),
                            isPrimaryFocus: false,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                    cwAccountBio(context, box.get(FireUserField.bio, defaultValue: ''), ifMine: true),
                    verticalSpaceLarge,
                    cwAccountInterests(
                        context, box.get(FireUserField.interests)),
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
