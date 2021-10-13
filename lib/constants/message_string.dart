class DocumentField {
  static const String type = 'type';
  static const String isRead = 'isRead';
  static const String isReply = 'isReply';
  static const String message = 'message';
  static const String senderUid = 'senderUid';
  static const String timestamp = 'timestamp';
  static const String messageUid = 'messageUid';
  static const String replyMessage = 'replyMessage';
}

class MessageField {
  static const String uploaded = 'uploaded';
  static const String location = 'location';
  static const String mediaURL = 'mediaURL';
  static const String timestamp = 'timestamp';
  static const String messageText = 'messageText';
}

class ReplyField {
  static const String replyType = 'replyType';
  static const String replyLocation = 'replyLocation';
  static const String replyMediaUrl = 'replyMediaUrl';
  static const String replyMediaList = 'replyMediaList';
  static const String replyMediaType = 'replyMediaType';
  static const String replySenderUid = 'replySenderUid';
  static const String replyMessageUid = 'replyMessageUid';
  static const String replyMessageText = 'replyMessageText';
}

class MediaType {
  static const String url = 'URL';
  static const String text = 'text';
  static const String meme = 'meme';
  static const String image = 'image';
  static const String video = 'video';
  static const String emoji = 'emoji';
  static const String canvasImage = 'canvasImage';
  static const String pixaBayImage = 'pixaBayImage';
}

class MsgRead {
  static const String sended = 'sended';
  static const String unread = 'unread';
  static const String readed = 'readed';
}
