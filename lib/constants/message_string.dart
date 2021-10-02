class DocumentField {
  static const String isRead = 'isRead';
  static const String isReply = 'isReply';
  static const String message = 'message';
  static const String messageUid = 'messageUid';
  static const String replyMessage = 'replyMessage';
  static const String senderUid = 'senderUid';
  static const String timestamp = 'timestamp';
  static const String type = 'type';
}

class MessageField {
  static const String location = 'location';
  static const String timestamp = 'timestamp';
  static const String mediaUrls = 'mediaUrls';
  static const String messageText = 'messageText';
  static const String mediaUrlsType = 'mediaUrlsType';
}

class ReplyField {
  static const String replyType = 'replyType';
  static const String replyMessageText = 'replyMessageText';
  static const String replyMediaUrl = 'replyMediaUrl';
  static const String replyMediaList = 'replyMediaList';
  static const String replyMediaType = 'replyMediaType';
  static const String replyLocation = 'replyLocation';
  static const String replyMessageUid = 'replyMessageUid';
  static const String replySenderUid = 'replySenderUid';
}

class MediaType {
  static const String text = 'text';
  static const String image = 'image';
  static const String video = 'video';
  static const String audio = 'audio';
  static const String pdf = 'pdf';
  static const String multiMedia = 'multiMedia';
  static const String url = 'URL';
  static const String dickster = 'dickster';
  static const String emoji = 'emoji';
}

class MsgRead {
  static const String sended = 'sended';
  static const String unread = 'unread';
}
