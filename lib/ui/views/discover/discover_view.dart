import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/loading_list_item.dart';
import 'package:hint/ui/views/discover/widgets/dule_person.dart';
import 'package:hint/ui/shared/empty_list_ui.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';
import 'package:hint/ui/views/discover_interest/discover_interest_view.dart';
import 'package:hint/ui/views/saved_people/saved_people_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'discover_viewmodel.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

  AppBar _buildAppBar(BuildContext context, DiscoverViewModel model) {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: 60,
      leadingWidth: 0,
      title: Text(
        'Discover',
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.black,
            fontSize: 32),
      ),
      actions: [
        IconButton(
          onPressed: () {
            model.discoverRefreshKey.currentState?.show();
          },
          icon: const Icon(FeatherIcons.refreshCcw),
          color: Theme.of(context).colorScheme.black,
          iconSize: 24,
        ),
        IconButton(
          onPressed: () {
            navService.cupertinoPageRoute(context, const SavedPeopleView());
          },
          icon: const Icon(FeatherIcons.pocket),
          color: Theme.of(context).colorScheme.black,
          iconSize: 24,
        ),
        horizontalSpaceSmall
      ],
      backgroundColor: MaterialStateColor.resolveWith(
        (Set<MaterialState> states) {
          return states.contains(MaterialState.scrolledUnder)
              ? Theme.of(context).colorScheme.lightGrey
              : Theme.of(context).colorScheme.scaffoldColor;
        },
      ),
    );
  }

  Widget _buildExploreInterestList(
      BuildContext context, List<String> interestList) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          scrollDirection: Axis.horizontal,
          itemCount: interestList.length,
          itemBuilder: (context, i) {
            return exploreInterestChip(
              context,
              interestList[i],
              onTap: () {
                navService.materialPageRoute(context,
                    DiscoverInterestView(interestName: interestList[i]));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiscoverViewModel>.reactive(
      onModelReady: (model) {
        model.peopleSuggestions();
      },
      viewModelBuilder: () => DiscoverViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: _buildAppBar(context, model),
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        body: RefreshIndicator(
          key: model.discoverRefreshKey,
          strokeWidth: 1,
          onRefresh: () async {
            model.onRefresh();
          },
          child: CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            slivers: [
              sliverVerticalSpaceMedium,
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Explore Interests',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.black,
                        fontSize: 20),
                  ),
                ),
              ),
              sliverVerticalSpaceRegular,
              ValueListenableBuilder<Box>(
                  valueListenable:
                      hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                  builder: (context, appSettingsBox, child) {
                    int firstListIndex = appSettingsBox
                        .get(AppSettingKeys.firstListIndex, defaultValue: 0);
                    return _buildExploreInterestList(
                        context, Interest.listOfInterestLists[firstListIndex]);
                  }),
              sliverVerticalSpaceTiny,
              ValueListenableBuilder<Box>(
                  valueListenable:
                      hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                  builder: (context, appSettingsBox, child) {
                    int secondListIndex = appSettingsBox
                        .get(AppSettingKeys.secondListIndex, defaultValue: 1);
                    return _buildExploreInterestList(
                        context, Interest.listOfInterestLists[secondListIndex]);
                  }),
              sliverVerticalSpaceLarge,
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Today\'s Top Picks',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.black,
                        fontSize: 20),
                  ),
                ),
              ),
              sliverVerticalSpaceRegular,
              FutureBuilder<QuerySnapshot>(
                future: model.peopleSuggestionsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, i) => loadingUserListItem(context,
                                showInterestChips: true),
                            childCount: 3));
                  }
                  final searchResults = snapshot.data!.docs;
                  return searchResults.isNotEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                          FireUser localFireUser =
                              FireUser.fromFirestore(snapshot.data!.docs[i]);
                          return dulePerson(context, model, localFireUser);
                        }, childCount: searchResults.length))
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: buildEmptyListUi(
                              context,
                              title: 'More interest\n More friends',
                              buttonTitle: 'Add interests',
                              color: Theme.of(context)
                                  .colorScheme
                                  .yellowAccent
                                  .withAlpha(80),
                            ),
                          ),
                        );
                },
              ),
              sliverVerticalSpaceLarge,
              SliverToBoxAdapter(child: bottomPadding(context)),
            ],
          ),
        ),
      ),
    );
  }
}
