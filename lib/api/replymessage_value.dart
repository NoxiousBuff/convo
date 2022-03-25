import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hint/models/message_model.dart';

// class GetReplyMessageValue extends ChangeNotifier {
//   String? _messageUid;
//   String? get messageUid => _messageUid;

//   String? _messageType;
//   String? get messageType => _messageType;

//   String? _messageText;
//   String? get messageText => _messageText;

//   String? _mediaURL;
//   String? get messageURL => _mediaURL;

//   bool _isReply = false;
//   bool get isReply => _isReply;

//   String? _senderUid;
//   String? get senderUid => _senderUid;

//   String? _documentTitle;
//   String? get documentTitle => _documentTitle;

//   /// change the value of isReply bool
//   void isReplyValChanger(bool val) {
//     _isReply = val;
//     notifyListeners();
//     log('GetReplyMessageValue => isReplyValue:$_isReply');
//   }

//   /// get the data of swiped message
//   void getSwipedMsgValue({
//     required String swipedMsgUid,
//     required String swipedMsgType,
//     required String swipedMsgsenderUid,
//     String? swipedMsgText,
//     String? swipedMediaURL,
//     String? swipedDocumentTitle,
//   }) {
//     _messageUid = swipedMsgUid;
//     _messageType = swipedMsgType;
//     _messageText = swipedMsgText;
//     _mediaURL = swipedMediaURL;
//     _senderUid = swipedMsgsenderUid;
//     _documentTitle = swipedDocumentTitle;
//     notifyListeners();
//     log('GetReplyMessageValue => swipedMsgUid:$_messageUid');
//     log('GetReplyMessageValue => swipedMsgType:$_messageType');
//     log('GetReplyMessageValue => swipedMsgText:$_messageText');
//     log('GetReplyMessageValue => swipedMediaURL:$_mediaURL');
//     log('GetReplyMessageValue => swipedMsgsenderUid:$_senderUid');
//     log('GetReplyMessageValue => swipedDocumentTitle:$_documentTitle');
//   }

//   void clearReplyMsg() {
//     _messageUid = null;
//     _messageType = null;
//     _messageText = null;
//     _mediaURL = null;
//     _senderUid = null;
//   }
// }

abstract class GetReplyMessageValue extends ChangeNotifier {
  /// get the unique identity of a message [Uid]
  /// and the unique id of message we call messageuid
  //String get messageUid;

  /// get the message value
  Message get message;

  /// get the type of message
  /// e.g text, image, video, document
  //String get messageType;

  /// get the text of the message if available
  //String? get messageText;

  /// get the url of the media if available
  //String? get mediaURL;

  /// get the value of isReply bool
  /// if user is replying to a specific message then
  /// its value is true default false
  bool get isReply;

  /// get the senderuid
  /// unique id of a user, after getting this
  /// its decided the message sended by me OR another user
  String? get senderUid;

  /// get the title OR name of document
  //String? get documentTitle;

  /// change the value of isReply bool
  void isReplyValChanger(bool val);

  /// get the data of swiped message
  // void getSwipedMsgValue({
  //   required String swipedMsgUid,
  //   required String swipedMsgType,
  //   required String swipedMsgsenderUid,
  //   String? swipedMsgText,
  //   String? swipedMediaURL,
  //   String? swipedDocumentTitle,
  // });

  /// clear the all value
  void clearReplyMsg();

  /// get swiped Message all its value
  void getSwipedMsg(Message msg);
}

class ReplyMessageImplimentation extends GetReplyMessageValue {
  ///  The unique identity of a message [Uid]
  /// and the unique id of message we call messageuid
  //String? _messageUid;

  /// The type of message
  /// e.g text, image, video, document
  //String? _messageType;

  /// The text of the message if available
  //String? _messageText;

  /// The Url of the media message if available
  //String? _mediaURL;

  /// get the value of isReply bool
  /// if user is replying to a specific message then
  /// its value is true default false
  bool _isReply = false;

  /// The senderUid
  /// unique id of a user, after getting this
  /// its decided the message sended by me OR another user
  String? _senderUid;

  /// The title OR name of document
  //String? _documentTitle;

  Message? _message;

  @override
  void clearReplyMsg() {
    _message = null;
    notifyListeners();
  }

  // @override
  // String? get documentTitle => _documentTitle;

  // @override
  // void getSwipedMsgValue({
  //   required String swipedMsgUid,
  //   required String swipedMsgType,
  //   required String swipedMsgsenderUid,
  //   String? swipedMsgText,
  //   String? swipedMediaURL,
  //   String? swipedDocumentTitle,
  // }) {
  //   _messageUid = swipedMsgUid;
  //   _messageType = swipedMsgType;
  //   _messageText = swipedMsgText;
  //   _mediaURL = swipedMediaURL;
  //   _senderUid = swipedMsgsenderUid;
  //   _documentTitle = swipedDocumentTitle;
  //   notifyListeners();
  //   log('GetReplyMessageValue => swipedMsgUid:$_messageUid');
  //   log('GetReplyMessageValue => swipedMsgType:$_messageType');
  //   log('GetReplyMessageValue => swipedMsgText:$_messageText');
  //   log('GetReplyMessageValue => swipedMediaURL:$_mediaURL');
  //   log('GetReplyMessageValue => swipedMsgsenderUid:$_senderUid');
  //   log('GetReplyMessageValue => swipedDocumentTitle:$_documentTitle');
  // }

  @override
  void getSwipedMsg(Message msg) {
    _message = msg;
    notifyListeners();
    log('Message:$_message');
  }

  @override
  bool get isReply => _isReply;

  @override
  void isReplyValChanger(bool val) {
    _isReply = val;
    notifyListeners();
    log('GetReplyMessageValue => isReplyValue:$_isReply');
  }

  // @override
  // String? get messageText => _messageText;

  // @override
  // String get messageType => _messageType!;

  // @override
  // String? get mediaURL => _mediaURL;

  // @override
  // String get messageUid => _messageUid!;

   @override
   String? get senderUid => _senderUid;

  @override
  Message get message => _message!;
}
