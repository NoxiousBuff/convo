import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/pods/genral_code.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/views/register/user_interests/user_interest.dart';
import 'package:hint/ui/views/register/verify_phone/code_verification.dart';

class CodeVerificationViewModel extends BaseViewModel {
  final log = getLogger('VerifyPhone');
  final formKey = GlobalKey<FormState>();
  final FocusNode pinPutFocusNode = FocusNode();
  final TextEditingController pinPutController = TextEditingController();

  Future<void> resend(String phoneNumber, BuildContext context) async {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        final pod = context.read(codeProvider);
        final localSmsCode = credential.smsCode;
        if (localSmsCode != null) pod.getCode(localSmsCode);
        pod.getPhoneCredentials(credential);
        log.wtf('credential.smsCode : $localSmsCode');
        log.wtf('Verification Completed Successfuly.');
        log.wtf('Phone Auth Credential: ${pod.phoneAuthCredential}');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e('The provided phone number is not valid.');
        } else {
          log.e('This was the error in creating phone auth credu=ntial : $e');
        }
      },
      codeSent: (String verificationId, [forceResendingToken]) async {
        // Update the UI - wait for the user to enter the SMS code

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: forceResendingToken.toString());
        log.w('Phone Auth Credential: $credential');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  Future<void> verifyCode(
    BuildContext context, {
    required String email,
    required String smsCode,
    required String username,
    required User? createdUser,
    required String phoneNumber,
    required String verificationId,
    required String countryPhoneCode,
  }) async {
    setBusy(true);

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await AuthService.liveUser!.updatePhoneNumber(phoneAuthCredential);
      if (createdUser != null) {
        Navigator.push(
          context,
          cupertinoTransition(
            enterTo: InterestsView(
              email: email,
              username: username,
              createdUser: createdUser,
              phoneNumber: phoneNumber,
              countryPhoneCode: countryPhoneCode,
            ),
            exitFrom: CodeVerificationView(
              email: email,
              username: username,
              createdUser: createdUser,
              phoneNumber: phoneNumber,
              countryPhoneCode: countryPhoneCode,
            ),
          ),
        );
      }
    } on FirebaseAuthException {
      setBusy(false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: systemRed,
          content: Text(
            'Verification Failed',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: systemBackground),
          ),
        ),
      );
    }
    setBusy(false);
  }
}
