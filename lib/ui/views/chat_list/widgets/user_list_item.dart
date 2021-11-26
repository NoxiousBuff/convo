import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/ui/views/dule/dule_view.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.userUid}) : super(key: key);
  final String userUid;

  Widget userStatus(FireUser fireUser) {
    return StreamBuilder<Event?>(
        stream: FirebaseDatabase.instance
            .reference()
            .child(dulesRealtimeDBKey)
            .child(fireUser.id)
            .onValue,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            final snapshot = data.snapshot;
            final json = snapshot.value.cast<String, dynamic>();
            final duleModel = DuleModel.fromJson(json);
            bool isOnline = duleModel.online;
            return Text(
              isOnline ? 'Online' : 'Offline',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: isOnline ? AppColors.green : AppColors.darkGrey),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection(usersFirestoreKey)
          .doc(userUid)
          .get(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasError) {
          return const Center(
            child: Text('It has Error'),
          );
        }
        if (!snapshot.hasData) {
          return loadingUserListItem(context);
        } else {
          if (data != null) {
            final fireUser = FireUser.fromFirestore(data);
            return ListTile(
              onTap: () async {
                String liveUserUid = AuthService.liveUser!.uid;
                String value =
                    chatService.getConversationId(fireUser.id, liveUserUid);
                navService.cupertinoPageRoute(
                    context, DuleView(fireUser: fireUser));
                await databaseService.updateUserDataWithKey(
                    DatabaseMessageField.roomUid, value);
              },
              leading: ClipOval(
                child: ExtendedImage(image: NetworkImage(fireUser.photoUrl)),
              ),
              title: Text(
                fireUser.displayName,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: userStatus(fireUser),
            );
          }
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: loadingUserListItem(context),
        );
      },
    );
  }

  Widget loadingUserListItem(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: ClipOval(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade300.withAlpha(30),
                Colors.indigo.shade400.withAlpha(50),
              ],
              focal: Alignment.topLeft,
              radius: 0.8,
            ),
          ),
          height: 56.0,
          width: 56.0,
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.1)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: screenWidthPercentage(context, percentage: 0.4)),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
    );
  }
}

final Color randomColor = Color.fromARGB(Random().nextInt(256),
    Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
