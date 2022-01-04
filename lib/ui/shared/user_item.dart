import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';

class UserItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final String? subtitle;
  final bool showSubtitle;
  final FireUser fireUser;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final EdgeInsetsGeometry? contentPadding;
  const UserItem({
    Key? key,
    required this.title,
    required this.fireUser,
    required this.onTap,
    this.onLongPress,
    this.trailing,
    this.subtitle,
    this.contentPadding,
    this.showSubtitle = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      enableFeedback: true,
      contentPadding: contentPadding,
      onLongPress: onLongPress,
      onTap: onTap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      trailing: trailing ?? const SizedBox.shrink(),
      leading: userProfilePhoto(context, fireUser.photoUrl),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: showSubtitle ?
          Text(
            subtitle ?? fireUser.username,
            style: TextStyle(
              color: Theme.of(context).colorScheme.black,
            ),
          ) : shrinkBox,
    );
  }
}
