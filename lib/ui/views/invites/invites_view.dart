import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/contact_model.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/invites/widgets/contact_list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

import 'invites_viewmodel.dart';

class InvitesView extends StatelessWidget {
  const InvitesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InvitesViewModel>.reactive(
      viewModelBuilder: () => InvitesViewModel(),
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userContacts),
          builder: (context, box, child) {
            var hiveList = box.values.toList();
            List<ContactModel> contacts = hiveList.map((value) {
              var json = value.cast<String, dynamic>();
              return ContactModel.fromJson(json);
            }).toList();
            contacts.sort((a, b) => a.displayName
                .toLowerCase()
                .compareTo(b.displayName.toLowerCase()));
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
              appBar: cwAuthAppBar(context,
                  title: 'Invite Friend\'s',
                  onPressed: () => Navigator.pop(context)),
              body: hiveList.isEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🥳', style: TextStyle(fontSize: 80)),
                              verticalSpaceRegular,
                              const CWEAHeading('More the\nMerrier',
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textAlign: TextAlign.center),
                              verticalSpaceRegular,
                              cwEADescriptionTitle(
                                context,
                                'Invites your friends and family,\nbut only those who think are worth it.',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CWAuthProceedButton(
                            isLoading: model.isBusy,
                            buttonTitle: 'Connect your contacts',
                            onTap: () async {
                              await model.getContacts();
                              model.gettingNumbers();
                            },
                          ),
                        ),
                        verticalSpaceLarge,
                        bottomPadding(context)
                      ],
                    )
                  : CupertinoScrollbar(
                      isAlwaysShown: true,
                      child: CustomScrollView(
                        scrollBehavior: const CupertinoScrollBehavior(),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                return contactListItem(
                                  context,
                                  model,
                                  contacts[i],
                                );
                              },
                              childCount: contacts.length,
                            ),
                          ),
                          sliverVerticalSpaceLarge,
                          SliverToBoxAdapter(
                            child: bottomPadding(context),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
