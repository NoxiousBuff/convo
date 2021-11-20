import 'package:hint/constants/app_strings.dart';

class PhoneNumber {
  final String number;
  final String contactName;
  final String countryCode;

  PhoneNumber({required this.number, required this.contactName, required this.countryCode});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      number: json[PhoneNumberField.number],
      contactName: json[PhoneNumberField.contactName],
      countryCode: json[PhoneNumberField.countryCode],
    );
  }
}
