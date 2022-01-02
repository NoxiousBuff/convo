import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/discover_interest/widgets/interest_people_gridtile.dart';
import 'package:hint/ui/views/discover_interest/widgets/interest_toggle_button.dart';
import 'package:hint/ui/views/discover_interest/widgets/loading_grid_view.dart';
import 'package:stacked/stacked.dart';

import 'discover_interest_viewmodel.dart';

class DiscoverInterestView extends StatelessWidget {
  const DiscoverInterestView({Key? key, required this.interestName})
      : super(key: key);

  final String interestName;

  static const String id = '/DiscoverInterestView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiscoverInterestViewModel>.reactive(
      viewModelBuilder: () =>
          DiscoverInterestViewModel(interestName: interestName),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context,
            title: interestName, onPressed: () => Navigator.pop(context)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            slivers: [
              sliverVerticalSpaceLarge,
              sliverVerticalSpaceLarge,
              SliverToBoxAdapter(
                child: Text(
                  model.replaceString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w700),
                ),
              ),
              sliverVerticalSpaceRegular,
              SliverToBoxAdapter(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InterestToggleButton(interestName),
                ],
              )),
              sliverVerticalSpaceRegular,
              const SliverToBoxAdapter(
                child: Divider(),
              ),
              sliverVerticalSpaceRegular,
              Builder(
                builder: (context) {
                  final _data = model.data;
                  if (model.hasError) {
                    return const Center(
                      child: Text('It has Error'),
                    );
                  }
                  if (!model.dataReady) {
                    return loadingGridView(context);
                  }
                  final fireUserList = _data!.docs;
                  return fireUserList.isNotEmpty
                      ? SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                screenWidthPercentage(context, percentage: 0.5),
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final fireUser =
                                  FireUser.fromFirestore(fireUserList[index]);
                              return interestedPeopleGridTile(
                                  context, fireUser);
                            },
                            childCount: fireUserList.length,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: emptyState(
                            context,
                            emoji: '❔',
                            // emoji: '📜',
                            heading: 'We\'re still \nfinding someone',
                            description:
                                'People related to your interests \nare not in this category right now.',
                            upperGap: screenHeightPercentage(context,
                                percentage: 0.15),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
