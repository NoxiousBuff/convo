import 'dart:math';
import 'package:hint/pods/genral_code.dart';
import 'package:hint/services/auth_service.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/register/user_interests/user_intererst_viewmodel.dart';

List<String> get activityNames => _activityNames;

class InterestsView extends StatefulWidget {
  final String email;
  final String username;
  final String phoneNumber;
  final User? createdUser;
  const InterestsView({
    Key? key,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.createdUser,
  }) : super(key: key);

  @override
  State<InterestsView> createState() => _InterestsViewState();
}

class _InterestsViewState extends State<InterestsView> {
  final log = getLogger('InterestsView');
  @override
  void initState() {
    super.initState();
    updateCurrentUser();
  }

  Future<void> updateCurrentUser() async {
    final pod = context.read(codeProvider);
    final username = widget.username;
    final createdUser = widget.createdUser;
    if (createdUser != null) {
      await createdUser.updateDisplayName(username);
      log.wtf('username:${AuthService.liveUser!.displayName}');
      await createdUser.updatePhoneNumber(pod.phoneAuthCredential!);
      log.wtf('phoneNumber:${AuthService.liveUser!.phoneNumber}');
      log.wtf('photoURL:${AuthService.liveUser!.photoURL}');
    }
  }

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
                    await firestoreApi
                        .createUserInFirebase(
                            user: widget.createdUser!,
                            username: widget.username,
                            phoneNumber: widget.phoneNumber,
                            interests: model.selectedInterests)
                        .then((value) => log.wtf('user created in firestore'));
                    Navigator.push(
                      context,
                      cupertinoTransition(
                        enterTo: const ChatListView(),
                        exitFrom: InterestsView(
                          email: widget.email,
                          username: widget.username,
                          phoneNumber: widget.phoneNumber,
                          createdUser: widget.createdUser,
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
