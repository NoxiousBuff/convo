import 'package:cloud_firestore/cloud_firestore.dart';

class HintMessage {
  bool isRead;
  bool isReply;
  bool removeMessage;
  final Timestamp timestamp;
  final String senderUid;
  final String messageUid;
  final String messageType;
  final String messageReading;
  //-----------------------------------------//
  final dynamic mediaPathsType;
  final dynamic mediaPaths;
  final String? messageText;
  final dynamic replyMessage;
  final String? replyType;
  final String? replyUid;

  HintMessage({
    this.isRead = false,
    this.isReply = false,
    this.removeMessage = false,
    required this.messageUid,
    required this.senderUid,
    required this.timestamp,
    required this.messageType,
    required this.messageReading,
    //-----------------------------------------//
    this.mediaPaths,
    this.mediaPathsType,
    this.messageText,
    this.replyUid,
    this.replyType,
    this.replyMessage,
  });

  factory HintMessage.fromJson(Map<String, dynamic> json) {
    final finalTimestamp = json["timestamp"] as int;
    return HintMessage(
      isRead: json["isRead"] as bool,
      isReply: json["isReply"] as bool,
      removeMessage: json["removeMessage"] as dynamic,
      messageUid: json["messageUid"] as String,
      senderUid: json["senderUid"] as String,
      messageType: json["messageType"] as String,
      messageReading: json['messageReading'],
      timestamp: Timestamp.fromMillisecondsSinceEpoch(finalTimestamp),
      //-----------------------------------------//
      mediaPathsType: json["mediaPathsType"] as dynamic,
      mediaPaths: json["mediaPaths"] as dynamic,
      messageText: json["messageText"] as String?,
      replyUid: json["replyUid"] as String?,
      replyType: json["replyType"] as String?,
      replyMessage: json["replyMessage"] as dynamic,
    );
  }
}
