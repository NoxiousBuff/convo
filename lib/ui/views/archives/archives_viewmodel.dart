import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:stacked/stacked.dart';

class ArchiveViewModel extends BaseViewModel {
  Future<void> showTileOptions(FireUser fireUser, context) async {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpaceMedium,
              ListTile(
                onTap: () {
                  pushNotificationService.sendZap(
                    fireUser.id,
                    whenComplete: () => customSnackbars.successSnackbar(context,
                      title: 'He has been notified.'),
                  onError: () => customSnackbars.errorSnackbar(context,
                      title: 'There was some error in notifying. Please check your internet connection.'),
                  );
                  Navigator.pop(context);
                },
                leading: const Icon(FeatherIcons.zap),
                title: Text('Send Zap',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  navService.materialPageRoute(
                      context, WriteLetterView(fireUser: fireUser));
                },
                leading: const Icon(FeatherIcons.send),
                title: Text('Write a Letter',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18)),
              ),
              ListTile(
                onTap: () {
                  chatService.removeFromArchive(fireUser.id);
                  hiveApi.deleteFromArchivedUsers(fireUser.id);
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
