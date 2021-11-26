import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String id;
  final String bio;
  final String email;
  final String phone;
  final String country;
  final List<dynamic> hashTags;
  final List<dynamic>? blockedBy;
  final List<dynamic>? blocked;
  final String? romanticStatus;
  final String gender;
  final int? dob;
  final String photoUrl;
  final String displayName;
  final Map<String, dynamic> position;
  final List<dynamic> interests;
  final Timestamp userCreated;
  final String countryPhoneCode;
  final String username;

  FireUser({
    required this.id,
    required this.bio,
    required this.email,
    required this.phone,
    required this.country,
    required this.hashTags,
    required this.photoUrl,
    required this.displayName,
    required this.position,
    required this.interests,
    required this.userCreated,
    required this.countryPhoneCode,
    required this.username,
    this.blocked,
    this.blockedBy,
    this.dob,
    required this.gender,
    this.romanticStatus,
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
      position: doc[FireUserField.position],
      interests: doc[FireUserField.interests],
      userCreated: doc[FireUserField.userCreated],
      countryPhoneCode: doc[FireUserField.countryPhoneCode],
      username: doc[FireUserField.username],
      blocked: doc[FireUserField.blocked],
      blockedBy: doc[FireUserField.blockedBy],
      romanticStatus: doc[FireUserField.romanticStatus],
      dob: doc[FireUserField.dob],
      gender: doc[FireUserField.gender],
    );
  }
}
