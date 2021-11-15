import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String id;
  final String? bio;
  final String phone;
  final String email;
  final String status;
  final String username;
  final String? photoUrl;
  final dynamic position;
  final Timestamp lastSeen;
  final Timestamp userCreated;
  final String countryPhoneCode;
  final List<dynamic> interests;
  final List<dynamic>? blockedUsers;

  FireUser({
    this.bio,
    this.photoUrl,
    this.blockedUsers,
    required this.id,
    required this.email,
    required this.phone,
    required this.status,
    required this.lastSeen,
    required this.username,
    required this.position,
    required this.interests,
    required this.userCreated,
    required this.countryPhoneCode,
  });

  //deserializing the user document
  factory FireUser.fromFirestore(DocumentSnapshot doc) {
    return FireUser(
      id: doc['id'],
      bio: doc['bio'],
      email: doc['email'],
      phone: doc['phone'],
      status: doc['status'],
      photoUrl: doc['photoUrl'],
      username: doc['username'],
      lastSeen: doc['lastSeen'],
      position: doc['position'],
      interests: doc['interests'],
      userCreated: doc['userCreated'],
      blockedUsers: doc['blockedUsers'],
      countryPhoneCode: doc['countryPhoneCode'],
    );
  }
}
