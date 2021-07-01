import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? messageUid;
  final bool? isReply;
  final String? link;
  final GeoPoint? location;
  final String? mediaUrl;
  final String? messageText;
  final String? receiverUid;
  final String? replyMediaUrl;
  final String? replyMsg;
  final String? replyMsgId;
  final String? replyType;
  final String? replyUid;
  final String? senderUid;
  final String? status;
  final Timestamp? timestamp;
  final String? type;

  Message({
    this.isReply,
    this.link,
    this.location,
    this.mediaUrl,
    this.messageText,
    this.messageUid,
    this.receiverUid,
    this.replyMediaUrl,
    this.replyMsg,
    this.replyMsgId,
    this.replyType,
    this.replyUid,
    this.senderUid,
    this.status,
    this.timestamp,
    this.type,
  });

  //deserializing the user document
  factory Message.fromFirestore(DocumentSnapshot documentSnapshot) {
    return Message(
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
