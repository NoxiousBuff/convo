import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthViewModel extends BaseViewModel {
  final log = getLogger('PhoneAuth');

  final TextEditingController phoneTech = TextEditingController();

  PhoneAuthCredential? _phoneAuthCredential;
  PhoneAuthCredential? get phoneAuthCredential => _phoneAuthCredential;

  Future<void> signUpWithPhone() async {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneTech.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log.wtf('Verification Completed Successfuly.');
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => log.wtf('Phone auth is completed successfully.'))
            .catchError((e) => log.e(
                'There was an error in signing with credential. Error : $e'));
        log.w('Phone Auth Credential: $credential');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e('The provided phone number is not valid.');
        } else {
          log.e('This was the error in creating phone auth credu=ntial : $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
    // Update the UI - wait for the user to enter the SMS code
    String smsCode = '7591';

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    log.w('Phone Auth Credential: $credential');

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) => log.wtf('Phone auth is completed successfully.'))
            .catchError((e) => log.e(
                'There was an error in signing with credential. Error : $e'));
        log.w('Phone Auth Credential: $credential');
  },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
    // Auto-resolution timed out...
  },
    );
  }
}
