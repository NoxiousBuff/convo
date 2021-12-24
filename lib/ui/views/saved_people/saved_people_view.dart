import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/chat_list/widgets/user_list_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'saved_people_viewmodel.dart';

class SavedPeopleView extends StatelessWidget {
  const SavedPeopleView({Key? key}) : super(key: key);

  static const String id = '/SavedPeopleView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedPeopleViewModel>.reactive(
      viewModelBuilder: () => SavedPeopleViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'Saved People', onPressed: () {
          Navigator.pop(context);
        }),
        body: ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.savedPeopleHiveBox),
          builder: (context, box, child) {
            final savedPeopleList = box.values.toList();
            return savedPeopleList.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: savedPeopleList.length,
                    itemBuilder: (context, i) {
                      final savedUser = savedPeopleList[i];
                      return UserListItem(
                        userUid: savedUser,
                        onLongPress: (fireUser) {
                          model.showTileOptions(fireUser, context);
                        },
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: emptyState(context,
                        emoji: '📜',
                        heading: 'There\'s no one \nin your saved scroll',
                        description:
                            'Apparently you have not found people that\nyou\'d like to talk later.\n\nThis means you don\'t like people, right. \n\nWe declare you to be a introvert.'),
                  );
          },
        ),
      ),
    );
  }
}
