import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends BaseViewModel {

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
                  hiveApi.deleteFromArchivedUsers(fireuserId);
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
                onTap: () {
                  hiveApi.deleteFromArchivedUsers(fireuserId);
                  firestoreApi.deleteRecentUser(fireuserId);
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
}
