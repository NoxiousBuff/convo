import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage {
  final bool isRead;
  final bool isReply;
  final Map<String, dynamic>? message;
  final String messageUid;
  final Map<String, dynamic>? replyMessage;
  final String senderUid;
  final Timestamp timestamp;
  final String type;

  NewMessage({
    required this.isRead,
    required this.isReply,
    this.message,
    required this.messageUid,
    this.replyMessage,
    required this.senderUid,
    required this.timestamp,
    required this.type,
  });

  factory NewMessage.fromFirestor(DocumentSnapshot doc) {
    return NewMessage(
        isRead: doc['isRead'],
        isReply: doc['isReply'],
        message: doc['message'],
        messageUid: doc['messageUid'],
        replyMessage: doc['replyMessage'],
        senderUid: doc['senderUid'],
        timestamp: doc['timestamp'],
        type: doc['type']);
  }
}
