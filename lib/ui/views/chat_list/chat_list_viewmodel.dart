import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChatListViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ChatListViewModel');

  Stream<QuerySnapshot> recentChats() {
    return FirebaseFirestore.instance
        .collection(subsFirestoreKey)
        .doc(AuthService.liveUser!.uid)
        .collection(recentFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Future<void> showTileOptions(String fireuserId, context, bool pinned) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: screenHeightPercentage(context, percentage: 0.3),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  chatService.addToArchive(fireuserId);
                  hiveApi.addToArchivedUsers(fireuserId);
                  Navigator.pop(context);
                },
                leading: const Icon(CupertinoIcons.archivebox_fill),
                title: Text('Archive',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () {
                  firestoreApi.updateRecentUser(
                      fireUserUid: fireuserId,
                      value: pinned ? false : true,
                      propertyName: RecentUserField.pinned);
                  pinned
                      ? hiveApi.deleteFromPinnedUsers(fireuserId)
                      : hiveApi.addToPinnedUsers(fireuserId);
                  Navigator.pop(context);
                },
                leading: Icon(pinned
                    ? CupertinoIcons.pin_slash_fill
                    : CupertinoIcons.pin_fill),
                title: Text(pinned ? 'Remove Pinned' : 'Pinned',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () {
                  firestoreApi.deleteOnlyRecent(fireuserId);
                  Navigator.pop(context);
                },
                leading: const Icon(CupertinoIcons.delete_solid),
                title: Text('Delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Stream<QuerySnapshot> get stream => recentChats();
}
