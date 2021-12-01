import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/loading_list_item.dart';
import 'package:hint/ui/views/discover/widgets/dule_person.dart';
import 'package:hint/ui/shared/empty_list_ui.dart';
import 'package:hint/ui/views/discover/widgets/explore_interest_chip.dart';
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
        body: ListView(
          shrinkWrap: true,
          children: [
            verticalSpaceMedium,
            Padding(
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
            verticalSpaceRegular,
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: userInterest.moviesAndTelevision.length,
                itemBuilder: (context, i) {
                  return exploreInterestChip(
                      userInterest.moviesAndTelevision, i);
                },
              ),
            ),
            verticalSpaceTiny,
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: userInterest.personalFinance.length,
                itemBuilder: (context, i) {
                  return exploreInterestChip(userInterest.personalFinance, i);
                },
              ),
            ),
            verticalSpaceLarge,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Today\'s Top Picks',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
            verticalSpaceRegular,
            FutureBuilder<QuerySnapshot>(
              future: model.peopleSuggestionsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListView.separated(separatorBuilder: (context, i) => const Divider(),
                      shrinkWrap: true,
                    itemBuilder: (context, i) =>
                        loadingUserListItem(context, showInterestChips: true),
                    itemCount: 3,
                  );
                }
                final searchResults = snapshot.data!.docs;
                return searchResults.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, i) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, i) {
                          FireUser localFireUser =
                              FireUser.fromFirestore(snapshot.data!.docs[i]);
                          return dulePerson(context, model, localFireUser,
                              onTap: () {
                            log('ghbdfjbgjhfd');
                            // model.savePeopleinHive(localFireUser.id);
                          });
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: buildEmptyListUi(context,
                            title: 'More interest\n More friends',
                            buttonTitle: 'Add interests',
                            color: AppColors.taintedBackground),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
