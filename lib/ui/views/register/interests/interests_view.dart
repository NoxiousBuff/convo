import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:tcard/tcard.dart';
import 'interest_viewmodel.dart';

final List<String> _activityNames = [
  'Do Anything',
  'Clean',
  'Code',
  'Cook',
  'Create',
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
    child: Center(
      child: Text(
        _activityNames[index],
        style: GoogleFonts.poppins(fontSize: 24),
      ),
    ),
  ),
);

class InterestsView extends StatelessWidget {
  InterestsView({Key? key}) : super(key: key);

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
              TCard(cards: _cards),
            ],
          ),
        ),
      ),
    );
  }
}
