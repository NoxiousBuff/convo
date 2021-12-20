import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';

class UserItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? subtitle;
  final FireUser fireUser;
  final void Function()? onTap;
  final void Function()? onLongPress;
  const UserItem(
      {Key? key,
      required this.title,
      required this.fireUser,
      required this.onTap,
      this.onLongPress,
      this.trailing,
      this.subtitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: onLongPress,
      onTap: onTap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      trailing: trailing ?? const SizedBox.shrink(),
      leading: userProfilePhoto(context, fireUser.photoUrl),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          fireUser.displayName,
          style:  TextStyle(
            fontSize: 20,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: subtitle ??
          Text(
            fireUser.username,
            style:  TextStyle(
              color: AppColors.black,
            ),
          ),
    );
  }
}
