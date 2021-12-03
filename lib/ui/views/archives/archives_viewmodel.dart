import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends StreamViewModel<QuerySnapshot> {
  Stream<QuerySnapshot> archiveChats() {
    return FirebaseFirestore.instance
        .collection(subsFirestoreKey)
        .doc(AuthService.liveUser!.uid)
        .collection(archivesFirestorekey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  Future<void> showTileOptions(String fireuserId, context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: screenHeightPercentage(context, percentage: 0.25),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  chatService.removeFromArchive(fireuserId);
                  Navigator.pop(context);
                },
                leading: const Icon(CupertinoIcons.archivebox_fill),
                title: Text('Remove',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () => firestoreApi.deleteRecentUser(fireuserId),
                leading: const Icon(CupertinoIcons.delete_solid),
                title: Text('Delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                leading: const Icon(FeatherIcons.bellOff),
                title: Text('Diasble Notification',
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
  Stream<QuerySnapshot> get stream => archiveChats();
}