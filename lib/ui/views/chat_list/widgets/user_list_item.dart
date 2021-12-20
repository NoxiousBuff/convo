import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/extensions/query.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/ui/shared/user_item.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';

// ignore: must_be_immutable
class UserListItem extends StatelessWidget {
  bool pinned;
  final String userUid;
  final Function(FireUser fireUser)? onTap;
  final Function(FireUser fireUser)? onLongPress;
  EdgeInsetsGeometry? contentPadding;
  UserListItem({
    Key? key,
    required this.userUid,
    this.pinned = false,
    this.onTap,
    this.onLongPress,
    this.contentPadding,
  }) : super(key: key);

  final log = getLogger('UserListItem');

  Widget userStatus(FireUser fireUser) {
    return StreamBuilder<DatabaseEvent?>(
      stream: FirebaseDatabase.instance
          .ref()
          .child(dulesRealtimeDBKey)
          .child(fireUser.id)
          .onValue,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          final snapshot = data.snapshot;
          final json = snapshot.value;
          final duleModel = DuleModel.fromJson(json);
          bool isOnline = duleModel.online;
          return Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: isOnline ? AppColors.blue : AppColors.mediumBlack,),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection(subsFirestoreKey)
            .doc(userUid)
            .getSavy(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasError) {
            log.e('User List Item Error : ${snapshot.error}');
            return const Center(
              child: Text('It has Error: '),
            );
          }
          if (!snapshot.hasData) {
            child = shrinkBox;
          } else {
            FireUser fireUser = FireUser.fromFirestore(snapshot.data!);
            child = UserItem(
              contentPadding: contentPadding,
                fireUser: fireUser,
                onLongPress: () {
                  final function = onLongPress;
                  if (function != null) {
                    function(fireUser);
                  }
                },
                onTap: () {
                  final function = onTap;
                  if (function != null) {
                    function(fireUser);
                  } else {
                    chatService.startDuleConversation(context, fireUser);
                  }
                },
                title: fireUser.displayName,
                subtitle: userStatus(fireUser),);
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: child,
          );
        });
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
      leading: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
        child:  Text(
          '',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
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
