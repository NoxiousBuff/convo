import 'package:hint/constants/app_strings.dart';

class ContactModel {
  final String countryPhoneCode;
  final String displayName;
  final bool existsinApp;
  final String phoneNumber;

  ContactModel({
    required this.countryPhoneCode,
    required this.displayName,
    required this.existsinApp,
    required this.phoneNumber,
  });

  ContactModel.fromJson(dynamic json)
      : countryPhoneCode = json[FireUserField.countryPhoneCode],
        displayName = json[FireUserField.displayName],
        existsinApp = json['ExistsInApp'],
        phoneNumber = json[FireUserField.phone];

  Map<String, dynamic> toJson() => {
        FireUserField.countryPhoneCode: countryPhoneCode,
        FireUserField.displayName: displayName,
        'ExistsInApp': existsinApp,
        FireUserField.phone: phoneNumber,
      };
}