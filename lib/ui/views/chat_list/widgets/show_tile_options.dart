import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';

Future<void> showTileOptions(FireUser fireUser, context, bool pinned) async {
  final firestoreApi = locator<FirestoreApi>();

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
                  // onComplete: () => customSnackbars.successSnackbar(context,
                  //     title: 'He has been notified.'),
                  onError: () => customSnackbars.errorSnackbar(context,
                      title: 'There was some error in notifying.'),
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
                chatService.addToArchive(fireUser.id);
                hiveApi.addToArchivedUsers(fireUser.id);
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
                    fireUserUid: fireUser.id,
                    value: pinned ? false : true,
                    propertyName: RecentUserField.pinned);
                pinned
                    ? hiveApi.deleteFromPinnedUsers(fireUser.id)
                    : hiveApi.addToPinnedUsers(fireUser.id);
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
                          firestoreApi.deleteOnlyRecent(fireUser.id);
                          Navigator.pop(context);
                        },
                        description:
                            'This will remove this item from your chat list.',
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
