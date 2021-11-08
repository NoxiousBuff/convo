import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_view.dart';
import 'package:hint/ui/views/register/verify_phone/code_verification.dart';

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

  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    return FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .where(UserField.phone, isEqualTo: phoneNumber)
        .get()
        .then((value) => value.size > 0 ? true : false)
        .catchError((e) {
      log.e('isPhoneNumberExists Error:$e');
    });
  }

  Future<void> getPhoneNumber(
    BuildContext context, {
    required String email,
    required String username,
    required User? createdUser,
    required String countryCode,
    required String phoneNumber,
  }) async {
    setBusy(true);
    try {
      bool isNumberExists = await isPhoneNumberExists(phoneNumber);
      if (isNumberExists) {
        Navigator.push(
          context,
          cupertinoTransition(
            enterTo: CodeVerificationView(
              email: email,
              username: username,
              createdUser: createdUser,
              phoneNumber: phoneNumber,
              countryPhoneCode: countryCode,
            ),
            exitFrom: PhoneAuthView(
              email: email,
              username: username,
              createdUser: createdUser,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: systemRed,
            content: Text(
              'This phone Number is already in use choose another',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: systemRed,
          content: Text(
            'Unable to sign up',
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

  Future<String> signUpWithPhone(String phoneNumber) async {
    String _verificationId = '';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e('The provided phone number is not valid.');
        } else {
          log.e('This was the error in creating phone auth credential : $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Create a PhoneAuthCredential with the code
        _verificationId = verificationId;
        notifyListeners();
        log.wtf('VerificationId:$verificationId');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );

    return _verificationId;
  }
}
