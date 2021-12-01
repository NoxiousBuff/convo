import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/loading_list_item.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

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
          .collection(subsFirestoreKey)
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
                chatService.startDuleConversation(context, fireUser);
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExtendedImage(
                  image: NetworkImage(fireUser.photoUrl),
                  height: 56,
                  width: 56,
                  fit: BoxFit.cover,
                  
                ),
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
}
