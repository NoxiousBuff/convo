import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool isReply;
  final String? link;
  final GeoPoint? location;
  final String? mediaUrl;
  final String? messageText;
  final String messageUid;
  final String receiverUid;
  final String? replyMediaUrl;
  final String? replyMsg;
  final String? replyMsgId;
  final String? replyType;
  final String? replyUid;
  final String? status;
  final String senderUid;
  final Timestamp timestamp;
  final String type;

  
Message({
    required this.isReply,
    this.link,
    this.location,
    this.mediaUrl,
    this.messageText,
    required this.messageUid,
    required this.receiverUid,
    this.replyMediaUrl,
    this.replyMsg,
    this.replyMsgId,
    this.replyType,
    this.replyUid,
    required this.senderUid,
    this.status,
    required this.timestamp,
    required this.type,
  });

  //deserializing the user document
  factory 
Message.fromFirestore(DocumentSnapshot documentSnapshot) {
    return 
  Message(
      isReply: documentSnapshot['isReply'],
      link: documentSnapshot['link'],
      location: documentSnapshot['location'],
      mediaUrl: documentSnapshot['mediaUrl'],
      messageText: documentSnapshot['messageText'],
      messageUid: documentSnapshot['messageUid'],
      receiverUid: documentSnapshot['receiverUid'],
      replyMediaUrl: documentSnapshot['replyMediaUrl'],
      replyMsg: documentSnapshot['replyMsg'],
      replyMsgId: documentSnapshot['replyMsgId'],
      replyType: documentSnapshot['replyType'],
      replyUid: documentSnapshot['replyUid'],
      senderUid: documentSnapshot['senderUid'],
      status: documentSnapshot['status'],
      timestamp: documentSnapshot['timestamp'],
      type: documentSnapshot['type'],
    );
  }
}
