import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String id;
  final String bio;
  final String email;
  final String phone;
  final String country;
  final List<dynamic> hashTags;
  final String photoUrl;
  final String username;
  final Map<String, dynamic> position;
  final List<dynamic> interests;
  final Timestamp userCreated;
  final String countryPhoneCode;

  FireUser({
    required this.id,
    required this.bio,
    required this.email,
    required this.phone,
    required this.country,
    required this.hashTags,
    required this.photoUrl,
    required this.username,
    required this.position,
    required this.interests,
    required this.userCreated,
    required this.countryPhoneCode,
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
      username: doc[FireUserField.username],
      position: doc[FireUserField.position],
      interests: doc[FireUserField.interests],
      userCreated: doc[FireUserField.userCreated],
      countryPhoneCode: doc[FireUserField.countryPhoneCode],
    );
  }
}
