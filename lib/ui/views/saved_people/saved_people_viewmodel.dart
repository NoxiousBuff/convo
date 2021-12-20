import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class SavedPeopleViewModel extends BaseViewModel {
  final log = getLogger('SavedPeopleViewModel');

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
                  Navigator.pop(context);
                  navService.materialPageRoute(context, WriteLetterView(fireUser: fireUser));
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
                  hiveApi.deleteFromSavedPeople(fireUser.id);
                  Navigator.pop(context);
                },
                leading: const Icon(FeatherIcons.trash2),
                title: Text('Remove From Saved People',
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