import 'dart:math';
import 'dart:convert';
import 'package:tcard/tcard.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/register/user_interests/user_intererst_viewmodel.dart';

List<String> get activityNames => _activityNames;

class InterestsView extends StatefulWidget {
  final String email;
  final String username;
  final String phoneNumber;
  final User? createdUser;
  final String countryPhoneCode;
  const InterestsView({
    Key? key,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.createdUser,
    required this.countryPhoneCode,
  }) : super(key: key);

  @override
  State<InterestsView> createState() => _InterestsViewState();
}

class _InterestsViewState extends State<InterestsView> {
  late GeoPoint geoPoint;
  final log = getLogger('InterestsView');
  @override
  void initState() {
    super.initState();
    lookUpGeopoint();
    updateCurrentUser();
  }

  Future<GeoPoint> lookUpGeopoint() async {
    final response =
        await http.get(Uri.parse('https://api.ipregistry.co?key=tryout'));

    if (response.statusCode == 200) {
      final latitude = json.decode(response.body)['location']['latitude'];
      final longitude = json.decode(response.body)['location']['longitude'];
      log.wtf('Latitide:$latitude');
      log.wtf('Longitude:$longitude');

      setState(() {
        geoPoint = GeoPoint(latitude, longitude);
      });

      return GeoPoint(latitude, longitude);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: inactiveGray,
          content: Text(
            'Turn On Your Internet',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: systemBackground),
          ),
        ),
      );
      throw Exception('Failed to get user country from IP address');
    }
  }

  Future<void> updateCurrentUser() async {
    final username = widget.username;
    final createdUser = widget.createdUser;

    if (createdUser != null) {
      await createdUser.reload();
      await createdUser.updateDisplayName(username);
      await createdUser.updatePhotoURL(AuthService.kDefaultPhotoUrl);
    }
  }

  @override
  void didUpdateWidget(covariant InterestsView oldWidget) {
    lookUpGeopoint();
    super.didUpdateWidget(oldWidget);
  }

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
                    'What do you like,',
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
                    'Select Your Interests At least 5 ',
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
                    log.wtf('user added in selectedInterests');
                    log.wtf('Length:${model.length()}');
                  }
                },
                onBack: (index, info) {
                  if (info.direction == SwipDirection.Left) {
                    log.wtf('not selected');
                  }
                },
              ),
              verticalSpaceLarge,
              CupertinoButton(
                color: activeBlue,
                onPressed: () async {
                  if (model.length() > 5) {
                    await model.createUserInDataBase(
                      context,
                      location: geoPoint,
                      email: widget.email,
                      username: widget.username,
                      createdUser: widget.createdUser,
                      phoneNumber: widget.phoneNumber,
                      countryPhoneCode: widget.countryPhoneCode,
                      selectedInterests: model.selectedInterests,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: inactiveGray,
                        content: Text(
                          'You must choose at least 5 interests',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: systemBackground),
                        ),
                      ),
                    );
                  }
                },
                child: model.isBusy
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation(systemBackground),
                        ),
                      )
                    : Text(
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

final List<String> _activityNames = [
  'Hobbies',
  'School Work',
  'Travel',
  'Entertainment',
  'Cooking',
  'Past Experience',
  'Inventions',
  'Future Plans',
  'Human Relationships',
  'Raise Money',
  'Experiment',
  'Spread Love',
  'Groove',
  'Relax',
  'Party',
  'Group Up',
  'Plan Ahead',
  'Play',
  'Do Nothing',
  'Shoot A Video',
  'Go Shopping',
  'Study Together',
  'Talk In Person',
  'Go  Somewhere',
];
