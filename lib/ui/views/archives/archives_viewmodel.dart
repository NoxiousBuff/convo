import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends BaseViewModel {
  Future<void> showTileOptions(String fireuserId, context) async {
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
                  chatService.removeFromArchive(fireuserId);
                  hiveApi.deleteFromArchivedUsers(fireuserId);
                  Navigator.pop(context);
                },
                leading: const Icon(FeatherIcons.folderMinus),
                title: Text('Remove From Archive',
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
}
