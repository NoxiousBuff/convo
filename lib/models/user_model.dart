import 'package:cloud_firestore/cloud_firestore.dart';

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

  FireUser(
      {required this.id,
      required this.email,
      this.photoUrl,
      this.bio,
      required this.status,
      required this.username,
      required this.userCreated,
      this.lastSeen, this.phone,});

  //deserializing the user document
  factory FireUser.fromFirestore(DocumentSnapshot doc) {
    return FireUser(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      status: doc['status'],
      username: doc['username'],
      userCreated: doc['userCreated'],
      lastSeen: doc['timestamp'],
      phone: doc['phone']
    );
  }
}
