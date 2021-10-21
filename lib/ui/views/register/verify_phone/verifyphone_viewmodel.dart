import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/pods/genral_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyPhone extends BaseViewModel {
  final log = getLogger('VerifyPhone');
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

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
}
