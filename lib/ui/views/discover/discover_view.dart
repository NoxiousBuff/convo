import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/loading_list_item.dart';
import 'package:hint/ui/views/discover/widgets/dule_person.dart';
import 'package:hint/ui/shared/empty_list_ui.dart';
import 'package:hint/ui/shared/explore_interest_chip.dart';
import 'package:hint/ui/views/discover_interest/discover_interest_view.dart';
import 'package:hint/ui/views/saved_people/saved_people_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'discover_viewmodel.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiscoverViewModel>.reactive(
      onModelReady: (model) {
        model.peopleSuggestions();
      },
      viewModelBuilder: () => DiscoverViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // shape: RoundedRectangleBorder(side: MaterialStateBorderSide.resolveWith((states) {
          //   return states.contains(MaterialState.scrolledUnder)
          // ? BorderSide(color: Colors.red, width: 3)
          // : BorderSide(color: Colors.black);
          // })),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          toolbarHeight: 60,
          leadingWidth: 0,
          title: const Text(
            'Discover',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, fontSize: 32),
          ),
          actions: [
            IconButton(
              onPressed: () {
                model.peopleSuggestions();
              },
              icon: const Icon(FeatherIcons.refreshCcw),
              color: Colors.black,
              iconSize: 24,
            ),
            IconButton(
              onPressed: () {
                navService.cupertinoPageRoute(context, const SavedPeopleView());
              },
              icon: const Icon(FeatherIcons.pocket),
              color: Colors.black,
              iconSize: 24,
            ),
            horizontalSpaceSmall
          ],
          backgroundColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            return states.contains(MaterialState.scrolledUnder)
                ? Colors.grey.shade50
                : Colors.white;
          }),
        ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            sliverVerticalSpaceMedium,
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Explore Interests',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    const Spacer(),
                    const Text(
                      'See All',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                    horizontalDefaultMessageSpace,
                    GestureDetector(
                      child: const Icon(
                        FeatherIcons.chevronRight,
                        color: Colors.black54,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            sliverVerticalSpaceRegular,
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  scrollDirection: Axis.horizontal,
                  itemCount: userInterest.moviesAndTelevision.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        navService.cupertinoPageRoute(context, DiscoverInterestView(interestName: userInterest.moviesAndTelevision[i]));
                      },
                      child: exploreInterestChip(
                          userInterest.moviesAndTelevision[i]),
                    );
                  },
                ),
              ),
            ),
            sliverVerticalSpaceTiny,
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  scrollDirection: Axis.horizontal,
                  itemCount: userInterest.automotive.length,
                  itemBuilder: (context, i) {
                    return exploreInterestChip(userInterest.automotive[i]);
                  },
                ),
              ),
            ),
            sliverVerticalSpaceLarge,
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Today\'s Top Picks',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
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
                          child: buildEmptyListUi(context,
                              title: 'More interest\n More friends',
                              buttonTitle: 'Add interests',
                              color: AppColors.taintedBackground),
                        ),
                      );
              },
            ),
            sliverVerticalSpaceLarge,
            SliverToBoxAdapter(child: bottomPadding(context)),
          ],
        ),
      ),
    );
  }
}
