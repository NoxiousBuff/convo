import 'package:hint/constants/app_strings.dart';

class RecentUser {
  final String uid;
  final int timestamp;

  RecentUser({required this.uid, required this.timestamp});

  RecentUser.fromJson(Map<String, dynamic> json)
      : uid = json[RecentUserField.uid],
        timestamp = json[RecentUserField.timestamp];

  Map<String, dynamic> toJson() => {
        RecentUserField.uid: uid,
        RecentUserField.timestamp: timestamp,
      };
}
