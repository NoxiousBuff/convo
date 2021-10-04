import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/model_string.dart';

class FireUser {
  final String id;
  final String email;
  final String? photoUrl;
  final String? bio;
  final String status;
  final String username;
  final Timestamp userCreated;
  final Timestamp? lastSeen;
  final String? phone;
  final int colorHexCode;
  final List<dynamic> interests;
  final String? country;

  FireUser({
    required this.id,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.status,
    required this.username,
    required this.userCreated,
    this.lastSeen,
    this.phone,
    required this.colorHexCode,
    required this.interests,
    this.country,
  });

  //deserializing the user document
  factory FireUser.fromFirestore(DocumentSnapshot doc) {
    return FireUser(
        id: doc[FireUserStrings.id],
        email: doc[FireUserStrings.email],
        photoUrl: doc[FireUserStrings.photoUrl],
        bio: doc[FireUserStrings.bio],
        status: doc[FireUserStrings.status],
        username: doc[FireUserStrings.username],
        userCreated: doc[FireUserStrings.userCreated],
        lastSeen: doc[FireUserStrings.lastSeen],
        phone: doc[FireUserStrings.phone],
        colorHexCode: doc[FireUserStrings.colorHexCode],
        interests: doc[FireUserStrings.interests],
        country: doc[FireUserStrings.country]
        );
  }
}

