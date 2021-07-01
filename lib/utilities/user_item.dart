import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/models/fire_user_model.dart';
import 'package:hint/services/chat_methods.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserItem extends StatelessWidget {
  final FireUser? fireUser;
  final ChatMethods chatMethods = ChatMethods();
  UserItem({this.fireUser});

  final Color randomColor = Color.fromARGB(Random().nextInt(256),
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

  buildChatListItemPopup({required FireUser fireUser}) {
    return Material(
      child: Container(
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
                  fireUser.username!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
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
                    fireUser.email!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Divider(color: Color(0x4D000000), thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.chat_bubble),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.phone),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.video_camera),
                ),
              ],
            ),
            SizedBox(height: 16.0)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        chatMethods.startConversation(
          context,
          fireUser!.id!,
          fireUser!.username,
          fireUser!.photoUrl,
          randomColor,
        );
      },
      shape: RoundedRectangleBorder(
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
                return buildChatListItemPopup(fireUser: fireUser!);
              });
        },
        child: ClipOval(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  randomColor.withAlpha(30),
                  randomColor.withAlpha(50),
                ],
                focal: Alignment.topLeft,
                radius: 0.8,
              ),
            ),
            height: 56.0,
            width: 56.0,
            child: Text(
              fireUser!.username![0],
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          fireUser!.username!,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: Text(
        fireUser!.email!,
      ),
    );
  }
}
