import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                        image: CachedNetworkImageProvider(fireUser.photoUrl!),
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
                icon: const Icon(CupertinoIcons.chat_bubble),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.phone),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.video_camera),
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
    return ValueListenableBuilder<Box>(
      valueListenable: hiveApi.appSettings.listenable(),
      builder: (context, box, child) {
        bool darkMode = box.get(HiveApi.darkModeKey,defaultValue: false);
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
                  style: TextStyle(
                    color: darkMode ? systemBackground : black,
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
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: darkMode ? systemBackground : black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: subtitle ?? Text(
            fireUser.email,
            style: TextStyle(
              color: darkMode ? systemBackground : black,
            ),
          ),
        );
      },
    );
  }
}
