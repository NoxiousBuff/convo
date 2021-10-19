import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:extended_image/extended_image.dart';


class EmailVerfication extends StatefulWidget {
  final User? firebaseUser;
  const EmailVerfication({Key? key, required this.firebaseUser})
      : super(key: key);

  @override
  State<EmailVerfication> createState() => _EmailVerficationState();
}

class _EmailVerficationState extends State<EmailVerfication>
    with WidgetsBindingObserver {
  final log = getLogger('EmailVerfication');

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!widget.firebaseUser!.emailVerified) {
        log.w('email is not verfied yet');
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 35),
      body: Center(
        child: Column(
          children: [
            verticalSpaceLarge,
            verticalSpaceLarge,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'we send a verfication email to your provided email address',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: lightBlue),
                textAlign: TextAlign.center,
              ),
            ),
            ExtendedImage(
              height: screenHeightPercentage(context, percentage: 0.5),
              width: screenWidth(context),
              image: const AssetImage('assets/email.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'If you did\'t receive any email go back to previous page and choose your username',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: inactiveGray),
                textAlign: TextAlign.center,
              ),
            ),
            CupertinoButton(
              color: activeBlue,
              onPressed: () {
                final firebaseUser = widget.firebaseUser;
                if (firebaseUser != null) {
                  if (firebaseUser.emailVerified) {
                    // Navigator.push(
                    //   context,
                    //   cupertinoTransition(
                    //     enterTo:  PhoneAuthView(),
                    //     exitFrom: EmailVerfication(
                    //       firebaseUser: widget.firebaseUser,
                    //     ),
                    //   ),
                    // );
                  } else {
                    log.w('email is not verified yet');
                  }
                } else {
                  log.w('Button: firebaseUser is null now');
                }
              },
              child: Text(
                'Already Verified',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: systemBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
