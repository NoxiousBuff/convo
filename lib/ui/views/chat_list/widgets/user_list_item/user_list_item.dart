import 'dart:math';

import 'package:hint/ui/views/chat_list/widgets/user_list_item/user_list_item_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/dule/dule_view.dart';
import 'package:hint/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable
class UserListItem extends StatelessWidget {
  bool pinned;
  final String userUid;
  UserListItem({
    Key? key,
    required this.userUid,
    this.pinned = false,
  }) : super(key: key);

  final log = getLogger('UserListItem');

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
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: isOnline ? AppColors.green : AppColors.darkGrey),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> updateRTDB(FireUser fireUser, BuildContext context) async {
    String liveUserUid = AuthService.liveUser!.uid;
    String value = chatService.getConversationId(fireUser.id, liveUserUid);

    await databaseService.updateUserDataWithKey(
        DatabaseMessageField.roomUid, value);
    navService.cupertinoPageRoute(context, DuleView(fireUser: fireUser));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserListItemViewModel>.reactive(
      viewModelBuilder: () => UserListItemViewModel(userUid),
      builder: (context, model, child) {
        final _data = model.data;
        if (model.hasError) {
          return const Center(
            child: Text('It has Error'),
          );
        }
        if (!model.dataReady) {
          return loadingUserListItem(context);
        } else {
          if (_data != null) {
            final fireUser = FireUser.fromFirestore(_data);
            return ListTile(
              onTap: () => updateRTDB(fireUser, context),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage(fireUser.photoUrl),
              ),
              title: Text(
                fireUser.displayName,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: userStatus(fireUser),
              trailing: pinned
                  ? Transform.rotate(
                      angle: pi / 180 - 5,
                      child: const Icon(CupertinoIcons.pin_fill))
                  : const SizedBox.shrink(),
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