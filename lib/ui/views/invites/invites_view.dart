import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/models/contact_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

import 'invites_viewmodel.dart';

class InVitesView extends StatefulWidget {
  const InVitesView({Key? key}) : super(key: key);

  @override
  State<InVitesView> createState() => _InVitesViewState();
}

class _InVitesViewState extends State<InVitesView> {
  final log = getLogger('invitesView');
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    final model = InvitesViewModel();
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      log.wtf("reach the bottom");
      model.changeReachIcon(FeatherIcons.arrowUp);
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      log.wtf("reach the top");
      model.changeReachIcon(FeatherIcons.arrowDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InvitesViewModel>.reactive(
      viewModelBuilder: () => InvitesViewModel(),
      onModelReady: (model) => model.getContacts(),
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
              backgroundColor: AppColors.white,
              appBar: cwAuthAppBar(context,
                  title: 'Invite Friend\'s',
                  onPressed: () => Navigator.pop(context)),
              body: hiveList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: cwAuthProceedButton(
                          context,
                          isLoading: model.isBusy,
                          buttonTitle: 'Connect your contacts',
                          onTap: () => model.gettingNumbers(),
                        ),
                      ),
                    )
                  : CupertinoScrollbar(
                      isAlwaysShown: true,
                      controller: scrollController,
                      notificationPredicate: (ScrollNotification notification) {
                        return true;
                      },
                      child: CustomScrollView(
                        scrollBehavior: const CupertinoScrollBehavior(),
                        controller: scrollController,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                var contact = contacts[i];
                                var number = contact.phoneNumber;
                                var code = contact.countryPhoneCode;
                                const padding =
                                    EdgeInsets.fromLTRB(16, 0, 16, 0);
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: padding,
                                        child: cwEADetailsTile(
                                          context,
                                          contact.displayName,
                                          showTrailingIcon: false,
                                          subtitle: '$code $number',
                                        ),
                                      ),
                                    ),
                                    horizontalSpaceRegular,
                                    Container(
                                      width: 80,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                          color: AppColors.blue,
                                          borderRadius:
                                              BorderRadius.circular(14.2)),
                                      child: const Center(
                                        child: Text(
                                          'Invite',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                              childCount: contacts.length,
                            ),
                          ),
                        ],
                      ),
                    ),
              floatingActionButton: model.showReachIcon
                  ? InkWell(
                      onTap: () {
                        if (model.reachIcon == FeatherIcons.arrowDown) {
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        } else {
                          scrollController.jumpTo(
                              scrollController.position.minScrollExtent);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.blue,
                        child: Icon(
                          model.reachIcon,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}

