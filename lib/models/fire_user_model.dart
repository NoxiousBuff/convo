import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
  final String? id;
  final String? email;
  final String? photoUrl;
  final String? bio;
  final String? username;
  final Timestamp? timestamp;

  FireUser(
      {this.id,
      this.email,
      this.photoUrl,
      this.bio,
      this.username,
      this.timestamp});

  //deserializing the user document
  factory FireUser.fromFirestore(DocumentSnapshot doc) {
    return FireUser(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      username: doc['username'],
      timestamp: doc['timestamp'],
    );
  }
}
