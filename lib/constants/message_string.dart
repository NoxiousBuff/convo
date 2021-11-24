class DocumentField {
  static const String type = 'type';
  static const String isRead = 'isRead';
  static const String isReply = 'isReply';
  static const String message = 'message';
  static const String senderUid = 'senderUid';
  static const String timestamp = 'timestamp';
  static const String messageUid = 'messageUid';
  static const String userBlockMe = 'userBlockMe';
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

class ChatRoomField {
  static const String backgroungImage = 'backgroundImage';
}

class FireUserField {
  static const id = 'id';
  static const bio = 'bio';
  static const email = 'email';
  static const phone = 'phone';
  static const country = 'country';
  static const hashTags = 'hashTags';
  static const photoUrl = 'photoUrl';
  static const username = 'username';
  static const position = 'position';
  static const interests = 'interests';
  static const userCreated = 'userCreated';
  static const countryPhoneCode = 'countryPhoneCode';
}

class DatabaseMessageField {
  static const msgTxt = 'msgTxt';
  static const roomUid = 'roomUid';
  static const url = 'url';
  static const urlType = 'urlType';
  static const online = 'online';
  static const aniType = 'aniType';
}

class AnimationType {
  static const confetti = 'confetti';
  static const spotlight = 'spotlight';
}
