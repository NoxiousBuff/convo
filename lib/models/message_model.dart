import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/constants/app_strings.dart';

class Message {
  final bool isRead;
  final bool isReply;
  final LinkedHashMap<String, dynamic> message;
  final String messageUid;
  final LinkedHashMap<String, dynamic> replyMessage;
  final String senderUid;
  final Timestamp timestamp;
  final String type;

  Message({
    required this.isRead,
    required this.isReply,
    required this.message,
    required this.messageUid,
    required this.replyMessage,
    required this.senderUid,
    required this.timestamp,
    required this.type,
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