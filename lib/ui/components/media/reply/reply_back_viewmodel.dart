import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final replyBackProvider = ChangeNotifierProvider((ref) => ReplyBackViewModel());

class ReplyBackViewModel extends ChangeNotifier {
  bool _isMe = false;
  bool get isMe => _isMe;

  bool _showReply = false;
  bool get showReply => _showReply;

  String? _replySenderID;
  String? get replySenderID => _replySenderID;

  FireUser? _fireUser;
  FireUser? get fireUser => _fireUser;

  bool _isReply = false;
  bool get isReply => _isReply;

  LinkedHashMap<dynamic, dynamic>? _message;
  LinkedHashMap<dynamic, dynamic>? get message => _message;

  String? _messageUid;
  String? get messageUid => _messageUid;

  Timestamp? _timestamp;
  Timestamp? get timestamp => _timestamp;

  String? _messageType;
  String? get messageType => _messageType;

  void showReplyBool(bool reply) {
    _showReply = reply;
    notifyListeners();
  }

  void getSwipedValue({
    required FireUser fireuser,
    required bool isMeBool,
    required bool swipedReply,
    required LinkedHashMap<dynamic, dynamic> swipedMessage,
    required String swipedMessageUid,
    required Timestamp swipedTimestamp,
    required String swipedMessageType,
    required String swipedMessageSenderID,
  }) {
    _isMe = isMeBool;
    _fireUser = fireuser;
    _isReply = swipedReply;
    _message = swipedMessage;
    _timestamp = swipedTimestamp;
    _messageUid = swipedMessageUid;
    _messageType = swipedMessageType;
    _replySenderID = swipedMessageSenderID;
    notifyListeners();
  }

  void removeSwipeValue() {
    _isMe = false;
    _fireUser = null;
    _isReply = false;
    _message = null;
    _messageUid = null;
    _timestamp = null;
    _messageType = null;
    notifyListeners();
  }
}
