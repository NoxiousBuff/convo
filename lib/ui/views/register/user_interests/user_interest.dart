import 'dart:math';
import 'package:tcard/tcard.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/register/user_interests/user_intererst_viewmodel.dart';

final List<String> _activityNames = [
  'Hobbies',
  'School/Work',
  'Travel',
  'Entertainment'
      'Cooking',
  'Past Experience'
      'Create',
  'Future Plans',
  'Human Relationships'
      'Raise Money',
  'Experiment',
  'Spread Love',
  'Groove',
  'Group Up',
  'Relax',
  'Party',
  'Plan Ahead',
  'Play',
  'Do Nothing',
  'Shoot A Video',
  'Go Shopping',
  'Study Together',
  'Talk In Person',
  'Go  Somewhere',
];

List<String> get activityNames => _activityNames;

final List<Widget> _cards = List.generate(
  20,
  (index) => Card(
    elevation: 0,
    color: colors[Random().nextInt(16)],
    child: Center(
      child: Text(
        _activityNames[index],
        style: GoogleFonts.poppins(fontSize: 24),
      ),
    ),
  ),
);

class InterestsView extends StatelessWidget {
  final String email;
  final String username;
  final String phoneNumber;
  final User? createdUser;
  InterestsView({
    Key? key,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.createdUser,
  }) : super(key: key);

  final List<String> activityLocationNames = [
    // 'activities/anything.gif',
    // 'activities/clean.gif',
    // 'activities/code.gif',
    // 'activities/cooking.gif',
    // 'activities/create.gif',
    // 'activities/donate.gif',
    // 'activities/experiment.gif',
    // 'activities/greet.gif',
    // 'activities/groove.gif',
    // 'activities/group.gif',
    // 'activities/meditate.gif',
    // 'activities/party.gif',
    // 'activities/plan.gif',
    // 'activities/play.gif',
    // 'activities/random.gif',
    // 'activities/record.gif',
    // 'activities/shop.gif',
    // 'activities/study.gif',
    // 'activities/talk.gif',
    // 'activities/travel.gif',
  ];

  @override
  Widget build(BuildContext context) {
    final log = getLogger('InterestView');
    return ViewModelBuilder<InterestsViewModel>.reactive(
      viewModelBuilder: () => InterestsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: systemBackground,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Icon(
                CupertinoIcons.heart,
                size: 70.0,
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'What do you like,,',
                    style: GoogleFonts.openSans(
                        color: CupertinoColors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selct Your Interest, carefully though',
                    style: GoogleFonts.openSans(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              verticalSpaceMedium,
              TCard(
                cards: _cards,
                lockYAxis: true,
                onForward: (index, info) {
                  if (info.direction == SwipDirection.Right) {
                    model.addInterest(_activityNames[index]);
                  }
                },
              ),
              verticalSpaceLarge,
              CupertinoButton(
                onPressed: () async {
                  if (model.length() > 5) {
                    await firestoreApi
                        .createUserInFirebase(
                            user: createdUser!,
                            phoneNumber: phoneNumber)
                        .then((value) => log.wtf('user created in firestore'));
                    Navigator.push(
                      context,
                      cupertinoTransition(
                        enterTo: const ChatListView(),
                        exitFrom: InterestsView(
                          email: email,
                          username: username,
                          phoneNumber: phoneNumber,
                          createdUser: createdUser,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: systemBackground),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
