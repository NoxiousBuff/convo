import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/views/discover/widgets/dule_person.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'discover_viewmodel.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiscoverViewModel>.reactive(
      viewModelBuilder: () => DiscoverViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          appBar: AppBar(
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
                onPressed: () {},
                icon: const Icon(FeatherIcons.pocket),
                color: Colors.black,
                iconSize: 24,
              ),
              horizontalSpaceSmall
            ],
            elevation: 0.0,
            toolbarHeight: 60,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark),
            title: const Text(
              'Discover',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 32),
            ),
            backgroundColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              return states.contains(MaterialState.scrolledUnder)
                  ? Colors.grey.shade50
                  : Colors.white;
            }),
            leadingWidth: 0,
          ),
          backgroundColor: Colors.white,
          body: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                verticalSpaceMedium,
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
                  future: FirebaseFirestore.instance
                      .collection(subsFirestoreKey)
                      .where(FireUserField.interests,
                          arrayContainsAny: model.usersInterests.sublist(0,9)).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    final searchResults = snapshot.data!.docs;
                    return searchResults.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: searchResults.length,
                            itemBuilder: (context, i) {
                              FireUser localFireUser = FireUser.fromFirestore(
                                  snapshot.data!.docs[i]);
                              return dulePerson(model, localFireUser);
                            },
                          )
                        : const Text('hfkdshksjk');
                  },
                )
              ]),
        ),
      ),
    );
  }
}