import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';

class PhoneAuthViewModel extends BaseViewModel {
  final log = getLogger('PhoneAuth');

  final formKey = GlobalKey<FormState>();

  String _countryCode = '91';
  String get countryCode => _countryCode;

  final TextEditingController phoneTech = TextEditingController();

  PhoneAuthCredential? _phoneAuthCredential;
  PhoneAuthCredential? get phoneAuthCredential => _phoneAuthCredential;

  void getCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  Future<void> signUpWithPhone(String phoneNumber) async {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
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
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: resendToken.toString());
        log.w('Phone Auth Credential: $credential');

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => log.wtf('Phone auth is completed successfully.'))
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

  Future pickedCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
      exclude: <String>['KN', 'MF'],
      //Optional. Shows phone code before the country name.
      showPhoneCode: true,
      onSelect: (Country country) {
        getCode(country.phoneCode);
        log.wtf(country.phoneCode);
      },
      // Optional. Sets the theme for the country list picker.
      countryListTheme: CountryListThemeData(
        // Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
