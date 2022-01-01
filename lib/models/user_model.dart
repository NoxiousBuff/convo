import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String id;
  final String bio;
  final String email;
  final String phone;
  final String? country;
  final List<dynamic> hashTags;
  final List<dynamic>? blockedBy;
  final List<dynamic>? blocked;
  final String? romanticStatus;
  final String gender;
  final int? dob;
  final String photoUrl;
  final String displayName;
  final List<dynamic> interests;
  final Timestamp userCreated;
  final String countryPhoneCode;
  final String username;
  final List<dynamic> tokens;

  FireUser({
    required this.id,
    required this.bio,
    required this.email,
    required this.phone,
    required this.country,
    required this.hashTags,
    required this.photoUrl,
    required this.displayName,
    required this.interests,
    required this.userCreated,
    required this.countryPhoneCode,
    required this.username,
    this.blocked,
    this.blockedBy,
    this.dob,
    required this.gender,
    this.romanticStatus,
    required this.tokens,
  });

  //deserializing the user document
  factory FireUser.fromFirestore(DocumentSnapshot doc) {
    return FireUser(
      id: doc[FireUserField.id],
      bio: doc[FireUserField.bio],
      email: doc[FireUserField.email],
      phone: doc[FireUserField.phone],
      country: doc[FireUserField.country],
      hashTags: doc[FireUserField.hashTags],
      photoUrl: doc[FireUserField.photoUrl],
      displayName: doc[FireUserField.displayName],
      interests: doc[FireUserField.interests],
      userCreated: doc[FireUserField.userCreated],
      countryPhoneCode: doc[FireUserField.countryPhoneCode],
      username: doc[FireUserField.username],
      blocked: doc[FireUserField.blocked],
      blockedBy: doc[FireUserField.blockedBy],
      romanticStatus: doc[FireUserField.romanticStatus],
      dob: doc[FireUserField.dob],
      gender: doc[FireUserField.gender],
      tokens: doc[FireUserField.tokens]
    );
  }

  Map<String, dynamic> toJson() => {
        FireUserField.id: id,
        FireUserField.bio: bio,
        FireUserField.email: email,
        FireUserField.phone: phone,
        FireUserField.country: country,
        FireUserField.hashTags: hashTags,
        FireUserField.photoUrl: photoUrl,
        FireUserField.displayName: displayName,
        FireUserField.interests: interests,
        FireUserField.userCreated: userCreated,
        FireUserField.countryPhoneCode: countryPhoneCode,
        FireUserField.username: username,
        FireUserField.blocked: blocked,
        FireUserField.blockedBy: blockedBy,
        FireUserField.romanticStatus: romanticStatus,
        FireUserField.dob: dob,
        FireUserField.gender: gender,
        FireUserField.tokens : tokens,
      };

  @override
  String toString() {
    return '${FireUserField.id}: $id\n'
        '${FireUserField.bio}: $bio\n'
        '${FireUserField.email}: $email\n'
        '${FireUserField.phone}: $phone\n'
        '${FireUserField.country}: $country\n'
        '${FireUserField.hashTags}: $hashTags\n'
        '${FireUserField.photoUrl}: $photoUrl\n'
        '${FireUserField.displayName}: $displayName\n'
        '${FireUserField.interests}: $interests\n'
        '${FireUserField.userCreated}: $userCreated\n'
        '${FireUserField.countryPhoneCode}: $countryPhoneCode\n'
        '${FireUserField.username}: $username\n'
        '${FireUserField.blocked}: $blocked\n'
        '${FireUserField.blockedBy}: $blockedBy\n'
        '${FireUserField.romanticStatus}: $romanticStatus\n'
        '${FireUserField.dob}: $dob\n'
        '${FireUserField.gender}: $gender\n'
        '${FireUserField.tokens} : $tokens\n ';
  }
}
