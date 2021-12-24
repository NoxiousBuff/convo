import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_appbar.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_bio.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_button.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_header.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_interests.dart';
import 'package:hint/ui/views/account/account_view/widgets/account_save_indicator.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
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
        valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
            appBar: cwAccountAppBar(
              context,
              fireUser.username,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FeatherIcons.moreVertical),
                  color:Theme.of(context).colorScheme.black,
                  iconSize: 24,
                ),
                horizontalSpaceSmall
              ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                verticalSpaceRegular,
                cwAccountHeader(
                  context,
                  fireUser.photoUrl,
                  fireUser.displayName,
                  FireUserField.romanticStatus,
                  fireUser.hashTags,
                ),
                verticalSpaceLarge,
                Row(
                  children: [
                    Expanded(
                      child: cwAccountButton(
                        context,
                        'Message',
                        onTap: () {
                          chatService.startDuleConversation(context, fireUser);
                        },
                      ),
                    ),
                    horizontalSpaceSmall,
                    cwAccountIconButton(
                      context,
                      onTap: () => navService.materialPageRoute(
                          context,
                          WriteLetterView(
                            fireUser: fireUser,
                          )),
                    ),
                    horizontalSpaceSmall,
                    cwAccountSaveIndicator(context, fireUser.id),
                  ],
                ),
                verticalSpaceLarge,
                cwAccountBio(context, fireUser.bio),
                verticalSpaceLarge,
                cwAccountInterests(context, fireUser.interests),
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
