import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserItem extends StatelessWidget {
  final FireUser fireUser;
  final Widget? trailing;
  final Widget? subtitle;
  final void Function()? onTap;
  const UserItem(
      {Key? key,
      required this.fireUser,
      required this.onTap,
      this.trailing,
      this.subtitle
      })
      : super(key: key);

  buildChatListItemPopup({required FireUser fireUser}) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipOval(
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: ExtendedNetworkImageProvider(fireUser.photoUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fireUser.username,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fireUser.email,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 18.0),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0x4D000000), thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.messageCircle),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.phone),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.video),
              ),
            ],
          ),
          const SizedBox(height: 16.0)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
          onTap: onTap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          trailing: trailing ?? const SizedBox.shrink(),
          leading: GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return buildChatListItemPopup(fireUser: fireUser);
                  });
            },
            child: ClipOval(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,  
                ),
                height: 56.0,
                width: 56.0,
                child: Text(
                  fireUser.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              fireUser.username,
              style: const TextStyle(
                fontSize: 20,
                color: black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: subtitle ?? Text(
            fireUser.email,
            style: const TextStyle(
              color: black,
            ),
          ),
        );
  }
}
