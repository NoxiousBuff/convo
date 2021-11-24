import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_strings.dart';

class Message {
  final bool isRead;
  final bool isReply;
  final String type;
  final bool userBlockMe;
  final String senderUid;
  final String messageUid;
  final Timestamp timestamp;
  final LinkedHashMap<dynamic, dynamic> message;
  final LinkedHashMap<dynamic, dynamic>? replyMessage;

  Message({
    this.replyMessage,
    required this.type,
    required this.isRead,
    required this.isReply,
    required this.message,
    required this.messageUid,
    required this.senderUid,
    required this.timestamp,
    required this.userBlockMe,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      type: doc[DocumentField.type],
      isRead: doc[DocumentField.isRead],
      isReply: doc[DocumentField.isReply],
      message: doc[DocumentField.message],
      senderUid: doc[DocumentField.senderUid],
      timestamp: doc[DocumentField.timestamp],
      messageUid: doc[DocumentField.messageUid],
      userBlockMe: doc[DocumentField.userBlockMe],
      replyMessage: doc[DocumentField.replyMessage],
    );
  }
}
