import 'dart:developer';

import 'package:flutter/material.dart';

class GetReplyMessageValue extends ChangeNotifier {
  String? _messageUid;
  String? get messageUid => _messageUid;

  String? _messageType;
  String? get messageType => _messageType;

  String? _messageText;
  String? get messageText => _messageText;

  String? _mediaURL;
  String? get messageURL => _mediaURL;

  bool _isReply = false;
  bool get isReply => _isReply;

  String? _senderUid;
  String? get senderUid => _senderUid;

  String? _documentTitle;
  String? get documentTitle => _documentTitle;

  /// change the value of isReply bool
  void isReplyValChanger(bool val) {
    _isReply = val;
    notifyListeners();
    log('GetReplyMessageValue => isReplyValue:$_isReply');
  }

  /// get the data of swiped message
  void getSwipedMsgValue({
    required String swipedMsgUid,
    required String swipedMsgType,
    required String swipedMsgsenderUid,
    String? swipedMsgText,
    String? swipedMediaURL,
    String? swipedDocumentTitle,
  }) {
    _messageUid = swipedMsgUid;
    _messageType = swipedMsgType;
    _messageText = swipedMsgText;
    _mediaURL = swipedMediaURL;
    _senderUid = swipedMsgsenderUid;
    _documentTitle = swipedDocumentTitle;
    notifyListeners();
    log('GetReplyMessageValue => swipedMsgUid:$_messageUid');
    log('GetReplyMessageValue => swipedMsgType:$_messageType');
    log('GetReplyMessageValue => swipedMsgText:$_messageText');
    log('GetReplyMessageValue => swipedMediaURL:$_mediaURL');
    log('GetReplyMessageValue => swipedMsgsenderUid:$_senderUid');
    log('GetReplyMessageValue => swipedDocumentTitle:$_documentTitle');
  }

  void clearReplyMsg() {
    _messageUid = null;
    _messageType = null;
    _messageText = null;
    _mediaURL = null;
    _senderUid = null;
  }
}
