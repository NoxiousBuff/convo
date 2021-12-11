import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class UserItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? subtitle;
  final FireUser fireUser;
  final void Function()? onTap;
  const UserItem(
      {Key? key,
      required this.title,
      required this.fireUser,
      required this.onTap,
      this.trailing,
      this.subtitle})
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
                        image: CachedNetworkImageProvider(fireUser.photoUrl),
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
                fireUser.displayName,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: fireUser.photoUrl,
            height: 56,
            width: 56,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          fireUser.displayName,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: subtitle ?? Text(
        fireUser.email,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
