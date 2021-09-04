import 'package:flutter/material.dart';

class ReplyProvider extends ChangeNotifier {
  bool isReply = false;
  String? replyMsgId;
  String? replyUid;
  String? replyMsg;
  String? replyType;
  String? replyMediaUrl;

  void setReplyFields({
    required bool localIsReply,
    required String localReplyMsgId,
    required String localReplyUid,
    required String localReplyMsg,
    required String localReplyType,
    required String localReplyMediaUrl,
  }) {
    isReply = localIsReply;
    replyMsgId = localReplyMsgId;
    replyUid = localReplyUid;
    replyMsg = localReplyMsg;
    replyType = localReplyType;
    replyType = localReplyMediaUrl;
    notifyListeners();
  }

  void emptyReplyFields() {
    replyMsg = null;
    replyUid = null;
    replyMsgId = null;
    replyType = null;
    isReply = false;
    notifyListeners();
  }
}
