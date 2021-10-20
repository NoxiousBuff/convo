import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String id;
  final String? bio;
  final String email;
  final String status;
  final String? phone;
  final String username;
  final String? photoUrl;
  final Timestamp lastSeen;
  final Timestamp userCreated;
  final List<dynamic> interests;
  final List<dynamic>? blockedUsers;

  FireUser({
    this.bio,
    this.phone,
    this.photoUrl,
    this.blockedUsers,
    required this.id,
    required this.email,
    required this.status,
    required this.lastSeen,
    required this.username,
    required this.interests,
    required this.userCreated,
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
      interests: doc['interests'],
      userCreated: doc['userCreated'],
      blockedUsers: doc['blockedUsers'],
    );
  }
}
