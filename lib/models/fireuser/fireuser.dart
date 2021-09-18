// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'fireuser.g.dart';

// const String kDefaultPhotoUrl =
//       'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

// @JsonSerializable()
// class FireUser {
//   @JsonKey(required: true)
//   final String id;

//   @JsonKey(required: true)
//   final String email;

//   @JsonKey(required: true, defaultValue: kDefaultPhotoUrl)
//   final String? photoUrl;

//   @JsonKey(defaultValue: 'I am using Convo.')
//   final String? bio;

//   @JsonKey(required: true, defaultValue: false)
//   final bool status;

//   @JsonKey(required: true)
//   final String username;

//   @JsonKey(required: true)
//   final DateTime userCreated;


//   final DateTime? lastSeen;


//   final String? phone;

//   // @JsonKey(required: true)
//   // final Color color;

//   FireUser({
//     required this.id,
//     required this.email,
//     this.photoUrl,
//     this.bio,
//     required this.status,
//     required this.username,
//     required this.userCreated,
//     this.lastSeen,
//     this.phone,
//     // required this.color,
//   });

//   DateTime dateTimeFromTimestamp(Timestamp timestamp) {
//   return timestamp.toDate();
// }

//   factory FireUser.fromJson(Map<String, dynamic> json) => _$FireUserFromJson(json);

//   Map<String, dynamic> toJson() => _$FireUserToJson(this);

// }
