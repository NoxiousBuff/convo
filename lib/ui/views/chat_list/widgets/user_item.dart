import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserItem extends StatefulWidget {
  final FireUser fireUser;
  final Color randomColor;
  final void Function()? onTap;
  const UserItem(
      {Key? key,
      required this.fireUser,
      required this.onTap,
      required this.randomColor})
      : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool isFriend = false;
  bool requesteSended = false;
  final log = getLogger('UserItem');

  @override
  void initState() {
    super.initState();
    requestChecker(widget.fireUser.id);
  }

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

  Future<void> sendFriendRequest(String userUniqueId) async {
    await FirebaseFirestore.instance
        .collection(requestsFirestoreKey)
        .doc(userUniqueId)
        .set({
          'userUid': [widget.fireUser.id],
        })
        .catchError((e) => log.e)
        .whenComplete(() => log.wtf('Document Added'));
  }

  Future<void> requestChecker(String userUniqueId) async {
    final document = await FirebaseFirestore.instance
        .collection(requestsFirestoreKey)
        .doc(FirestoreApi.liveUserUid)
        .get();
    final doc = document.data()![CommonPropertiesInCollection.userUid];
    List<String> json = doc.cast<String>();

    switch (json.contains(userUniqueId)) {
      case true:
        {
          setState(() {
            requesteSended = true;
          });
        }

        break;
      case false:
        {
          final document = await FirebaseFirestore.instance
              .collection(friendsFirestoreKey)
              .doc(FirestoreApi.liveUserUid)
              .get();
          final doc = document.data()![CommonPropertiesInCollection.userUid];
          List<String> json = doc.cast<String>();
          if (json.contains(userUniqueId)) {
            setState(() {
              isFriend = true;
            });
          }
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: appSettings.listenable(),
      builder: (context, box, child) {
        bool darkMode = box.get(darkModeKey, defaultValue: false);
        return ListTile(
          onTap: widget.onTap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return buildChatListItemPopup(fireUser: widget.fireUser);
                  });
            },
            child: ClipOval(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      widget.randomColor.withAlpha(30),
                      widget.randomColor.withAlpha(50),
                    ],
                    focal: Alignment.topLeft,
                    radius: 0.8,
                  ),
                ),
                height: 56.0,
                width: 56.0,
                child: Text(
                  widget.fireUser.username[0].toUpperCase(),
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
              widget.fireUser.username,
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: darkMode ? systemBackground : black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: Text(
            widget.fireUser.email,
            style: TextStyle(
              color: darkMode ? systemBackground : black,
            ),
          ),
          trailing: isFriend
              ? const Text('Friend')
              : CupertinoButton(
                  color: activeBlue,
                  borderRadius: BorderRadius.circular(20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(requesteSended ? 'Sended' : 'ADD',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: systemBackground)),
                  onPressed: () => requestChecker(widget.fireUser.id),
                ),
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          //   child: Text('ADD', style: Theme.of(context).textTheme.bodyText1),
          // ),
        );
      },
    );
  }
}
