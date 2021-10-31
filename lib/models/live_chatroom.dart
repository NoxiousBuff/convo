import 'package:hint/constants/message_string.dart';

class LiveChatUser {
  final String documentID;
  final String collectionID;
  final dynamic permissions;
  final String liveChatRoomID;
  final String userUid;
  final String userMessage;

  LiveChatUser({
    required this.documentID,
    required this.collectionID,
    required this.permissions,
    required this.liveChatRoomID,
    required this.userUid,
    required this.userMessage,
    
  });

  factory LiveChatUser.fromJson(Map<String, dynamic> json) {
    return LiveChatUser(
      documentID: json['\$id'],
      collectionID: json['\$collection'],
      permissions: json['\$permissions'],
      liveChatRoomID: json[LiveChatField.liveChatRoom],
      userUid: json[LiveChatField.userUid],
      userMessage: json[LiveChatField.userMessage],
    );
  }
}
