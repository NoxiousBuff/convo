import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/settings/user_account/user_account_view.dart';

class ChatViewTitle extends StatelessWidget {
  final FireUser fireUser;
  const ChatViewTitle(this.fireUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          navService.materialPageRoute(context, const UserAccountView()),
      child: Row(
        children: [
          /// This display the profile photo of user
          UserProfilePhoto(
            fireUser.photoUrl,
            height: 36,
            width: 36,
            borderRadius: BorderRadius.circular(15),
          ),
          horizontalSpaceSmall,

          /// This will display the current Display name of a user
          Text(
            fireUser.displayName,
            style: TextStyle(color: Theme.of(context).colorScheme.black),
          ),
        ],
      ),
    );
  }
}
