import 'package:hint/constants/message_string.dart';

class AppwriteDocument {
  final String documentID;
  final String collectionID;
  final dynamic permissions;
  final String liveChatRoomID;
  final String firstUserID;
  final String secondUserID;
  final String? firstUserMessage;
  final String? secondUserMessage;

  AppwriteDocument({
    required this.documentID,
    required this.collectionID,
    required this.permissions,
    required this.liveChatRoomID,
    required this.firstUserID,
    required this.secondUserID,
    this.firstUserMessage,
    this.secondUserMessage,
  });

  factory AppwriteDocument.fromJson(Map<String, dynamic> json) {
    return AppwriteDocument(
      documentID: json['\$id'],
      collectionID: json['\$collection'],
      permissions: json['\$permissions'],
      liveChatRoomID: json['liveChatRoom'],
      firstUserID: json[LiveChatField.firstUserId],
      secondUserID: json[LiveChatField.secondUserId],
      firstUserMessage: json[LiveChatField.firstUserMessage],
      secondUserMessage: json[LiveChatField.secondUserMessage],
    );
  }
}
