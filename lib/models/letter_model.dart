import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_strings.dart';

class LetterModel {
  final String letterText;
  final String username;
  final String photoUrl;
  final String displayName;
  final String id;
  final Timestamp timestamp;

  LetterModel({
    required this.displayName,
    required this.id,
    required this.letterText,
    required this.photoUrl,
    required this.username,
    required this.timestamp,
  });

  //deserializing the model
  factory LetterModel.fromFireStore(DocumentSnapshot doc) {
    return LetterModel(
        displayName: doc[LetterFields.displayName],
        id: doc[LetterFields.id],
        letterText: doc[LetterFields.letterText],
        photoUrl: doc[LetterFields.photoUrl],
        username: doc[LetterFields.username],
        timestamp: doc[LetterFields.timestamp]);
  }

  Map<String, dynamic> toJson() => {
        LetterFields.id: id,
        LetterFields.photoUrl: photoUrl,
        LetterFields.displayName: displayName,
        LetterFields.username: username,
        LetterFields.letterText : letterText,
        LetterFields.timestamp : timestamp,
      };

  @override
  String toString() {
    return '${LetterFields.displayName} : $displayName\n'
        '${LetterFields.id} : $id\n'
        '${LetterFields.username} : $username\n'
        '${LetterFields.photoUrl} : $photoUrl\n'
        '${LetterFields.letterText} : $letterText\n'
        '${LetterFields.timestamp} : ${timestamp.toString()}';
  }
}