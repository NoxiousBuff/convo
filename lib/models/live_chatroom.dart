import 'package:hint/constants/message_string.dart';

class LiveChatUser {
  final String userUid;
  final String? mediaURL;
  final String? mediaType;
  final String documentID;
  final String userMessage;
  final String collectionID;
  final dynamic permissions;
  final String? liveChatRoomID;
  final String? animationType;

  LiveChatUser({
    required this.userUid,
    required this.mediaURL,
    required this.mediaType,
    required this.documentID,
    required this.permissions,
    required this.userMessage,
    required this.collectionID,
    required this.animationType,
    required this.liveChatRoomID,
  });

  factory LiveChatUser.fromJson(Map<String, dynamic> json) {
    return LiveChatUser(
      documentID: json['\$id'],
      collectionID: json['\$collection'],
      permissions: json['\$permissions'],
      userUid: json[LiveChatField.userUid],
      mediaURL: json[LiveChatField.mediaURL],
      mediaType: json[LiveChatField.mediaType],
      userMessage: json[LiveChatField.userMessage],
      liveChatRoomID: json[LiveChatField.liveChatRoom],
      animationType: json[LiveChatField.animationType],
    );
  }
}
