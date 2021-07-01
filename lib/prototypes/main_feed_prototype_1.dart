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
    'Go Somewhere',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: ListView(
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.width * 1.1,
          //   child: Stack(
          //     children: [
          //       // Padding(
          //       //   padding: EdgeInsets.only(
          //       //       bottom: MediaQuery.of(context).size.width * 0.1),
          //       //   child: Swiper(
          //       //     fade: 0.5,
          //       //     loop: true,
          //       //     layout: SwiperLayout.DEFAULT,
          //       //     scrollDirection: Axis.horizontal,
          //       //     scale: 0.9,
          //       //     viewportFraction: 0.8,
          //       //     itemCount: 20,
          //       //     itemWidth: MediaQuery.of(context).size.width * 0.80,
          //       //     itemHeight: MediaQuery.of(context).size.width,
          //       //     itemBuilder: (context, i) {
          //       //       return activityItem(
          //       //           context, activityLocationNames[i], activityNames[i]);
          //       //     },
          //       //   ),
          //       // ),
          //       Positioned(
          //         top: MediaQuery.of(context).size.width * 0.9,
          //         left: MediaQuery.of(context).size.width * 0.8,
          //         child: FloatingActionButton(
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => FullActivityView()));
          //           },
          //           child: Icon(Icons.arrow_forward),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(height: 12.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Color(0x4D000000),
                  width: 0.5, // One physical pixel.
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: AssetImage('images/img1.jpg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Message 1',
                        style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: CupertinoColors.black,
                            letterSpacing: -0.5),
                      ),
                    ),
                    subtitle: Text(
                      'SlidableDrawerDelegate',
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: AssetImage('images/img1.jpg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Message 1',
                        style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: CupertinoColors.black,
                            letterSpacing: -0.5),
                      ),
                    ),
                    subtitle: Text(
                      'SlidableDrawerDelegate',
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: AssetImage('images/img1.jpg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Message 1',
                        style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: CupertinoColors.black,
                            letterSpacing: -0.5),
                      ),
                    ),
                    subtitle: Text(
                      'SlidableDrawerDelegate',
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: AssetImage('images/img1.jpg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Message 1',
                        style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: CupertinoColors.black,
                            letterSpacing: -0.5),
                      ),
                    ),
                    subtitle: Text(
                      'SlidableDrawerDelegate',
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Row activityItem(
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
