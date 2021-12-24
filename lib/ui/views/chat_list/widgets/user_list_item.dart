import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
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
            style: TextStyle(
                color: isOnline ? Theme.of(context).colorScheme.blue : Theme.of(context).colorScheme.mediumBlack, fontSize: 14),
          );
        } else {
          return shrinkBox;
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
                subtitle: userStatus(fireUser),
                );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: child,
          );
        });
  }
}
