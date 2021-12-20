import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';

import 'archives_viewmodel.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({Key? key}) : super(key: key);

  @override
  _ArchiveViewState createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchiveViewModel>.reactive(
      viewModelBuilder: () => ArchiveViewModel(),
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: cwAuthAppBar(context, title: 'Archives', onPressed: () {
              Navigator.of(context).pop();
            }),
            body: ValueListenableBuilder<Box>(
              valueListenable: hiveApi.hiveStream(HiveApi.archivedUsersHiveBox),
              builder: (context, archivedUsersBox, child) {
                final archivedUsersList = archivedUsersBox.values.toList();

                return archivedUsersList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, i) {
                          final userUid = archivedUsersList[i];
                          return UserListItem(userUid: userUid, onLongPress: (fireUser) {
                            model.showTileOptions(fireUser, context);
                          },);
                        },
                        itemCount: archivedUsersList.length,
                      )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: emptyState(context,
                          emoji: '📦',
                          heading: 'Archives are\nempty',
                          description:
                              'There is no one in your archives. \nArchive people from the Convo page to seee people here.'),
                    );
              },
            ));
      },
    );
  }
}
