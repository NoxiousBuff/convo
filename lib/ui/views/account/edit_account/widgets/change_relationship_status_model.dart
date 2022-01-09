import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/relationship_status_list.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/edit_account_viewmodel.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

Future<void> showChangeRelationshipStatusModal(
    BuildContext context, EditAccountViewModel model) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
    context: context,
    builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                  child:
                      cwEADescriptionTitle(context, 'What\'s Your Status')),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                return cwEADetailsTile(context, relationshipStatusList[i],
                    onTap: () {
                  model.updateUserProperty(context,
                      FireUserField.romanticStatus, relationshipStatusList[i],
                      useSetBusy: false);
                  Navigator.pop(context);
                });
              }, childCount: relationshipStatusList.length)),
              SliverToBoxAdapter(
                child: cwEADetailsTile(context, 'Cancel',
                    titleColor: Colors.red, onTap: () {
                  Navigator.pop(context);
                }),
              ),
              SliverToBoxAdapter(child: bottomPadding(context)),
            ],
          ));
    },
  );
}
