import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
