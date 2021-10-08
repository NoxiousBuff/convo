import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/message_string.dart';

class Message {
  final bool isRead;
  final bool isReply;
  final String type;
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
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
        isRead: doc[DocumentField.isRead],
        isReply: doc[DocumentField.isReply],
        message: doc[DocumentField.message],
        messageUid: doc[DocumentField.messageUid],
        replyMessage: doc[DocumentField.replyMessage],
        senderUid: doc[DocumentField.senderUid],
        timestamp: doc[DocumentField.timestamp],
        type: doc[DocumentField.type],);
  }
}
