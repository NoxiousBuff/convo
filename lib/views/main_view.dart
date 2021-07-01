import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<String> activityLocationNames = [
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

  List<String> activityNames = [
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.width,
            //   child: ListView.builder(
            //     itemBuilder: (context, i) {
            //       return activityItemBuilder(
            //           context, activityLocationNames[i], activityNames[i]);
            //     },
            //     itemCount: 20,
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //   ),
            // ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Text(
                    'Nearby People',
                    style: GoogleFonts.openSans(
                        color: CupertinoColors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28.0,
                    backgroundImage: AssetImage('images/img$i.jpg'),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Message $i',
                      style: GoogleFonts.roboto(
                          fontSize: 20.0,
                          color: CupertinoColors.black,
                          letterSpacing: -0.5),
                    ),
                  ),
                  subtitle: Text(
                    'SlidableDrawerDelegate',
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Row activityItemBuilder(
    BuildContext context, String activityLocationName, String activityName) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            print(MediaQuery.of(context).size.width);
          },
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width * 0.75,
            padding: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Color(0x4D000000),
                width: 0.0, // One physical pixel.
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
                    Text('Let\'s'),
                    SizedBox(width: 4.0),
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
