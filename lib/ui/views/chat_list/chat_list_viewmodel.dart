import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpaceMedium,
              ListTile(
                onTap: () {
                  chatService.addToArchive(fireuserId);
                  hiveApi.addToArchivedUsers(fireuserId);
                  Navigator.pop(context);
                },
                leading: const Icon(FeatherIcons.folderPlus),
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
                leading: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Icon(
                    pinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 30,
                  ),
                ),
                title: Text(pinned ? 'Remove Pin' : 'Pin',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DuleAlertDialog(
                          iconBackgroundColor: Colors.red,
                            title: 'Delete this chat',
                            icon: FeatherIcons.trash,
                            primaryButtonText: 'Yes',
                            primaryOnPressed: () {
                              firestoreApi.deleteOnlyRecent(fireuserId);
                              Navigator.pop(context);
                            },
                            description: 'This will remove this item from your chat list.',
                            secondaryButtontext: 'No',
                            secondaryOnPressed: () {
                              Navigator.pop(context);
                            },
                            );
                      });
                  
                },
                leading: const Icon(FeatherIcons.trash),
                title: Text('Delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              verticalSpaceMedium,
              bottomPadding(context),
            ],
          ),
        );
      },
    );
  }

  @override
  Stream<QuerySnapshot> get stream => recentChats();
}
