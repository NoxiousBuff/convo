import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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
      backgroundColor: CupertinoColors.white,
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              'Let\'s',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[0]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[1]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[2]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[3]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[4]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[5]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[6]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[7]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[8]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[9]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[10]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[11]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[12]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[13]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[14]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[15]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[16]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[17]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[18]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(activityNames[19]),
                ),
              ],
              itemExtent: 50,
              looping: false,
              onSelectedItemChanged: (int index) {},
            ),
          ),
        ],
      ),
    );
  }
}
