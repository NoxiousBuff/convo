import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullActivityView extends StatefulWidget {
  const FullActivityView({Key? key}) : super(key: key);

  @override
  _FullActivityViewState createState() => _FullActivityViewState();
}

class _FullActivityViewState extends State<FullActivityView> {
  final List<String> _activityLocationName = [
    'activities/anything.gif',
    'activities/clean.gif',
    'activities/code.gif',
    'activities/cooking.gif',
    'activities/create.gif',
    'activities/donate.gif',
    'activities/experiment.gif',
    'activities/greet.gif',
    'activities/groove.gif',
    'activities/group.gif',
    'activities/meditate.gif',
    'activities/party.gif',
    'activities/plan.gif',
    'activities/play.gif',
    'activities/random.gif',
    'activities/record.gif',
    'activities/shop.gif',
    'activities/study.gif',
    'activities/talk.gif',
    'activities/travel.gif',
  ];

  final List<String> _activityName = [
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
    'Go Somewhere',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, i) {
          return activityItemVertical(
              context, _activityLocationName[i], _activityName[i]);
        },
        itemCount: 20,
      ),
    );
  }
}

Row activityItemVertical(
    BuildContext context, String activityLocationName, String activityName) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.width * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: const Color(0x4D000000),
                width: 0.5, // One physical pixel.
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  image: AssetImage(activityLocationName),
                  fit: BoxFit.cover,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Let\'s'),
                    const SizedBox(width: 4.0),
                    Chip(
                      label: Text(activityName),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
