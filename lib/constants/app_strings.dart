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
  static const String id = 'id';
  static const String bio = 'bio';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String country = 'country';
  static const String hashTags = 'hashTags';
  static const String photoUrl = 'photoUrl';
  static const String displayName = 'displayName';
  static const String position = 'position';
  static const String interests = 'interests';
  static const String userCreated = 'userCreated';
  static const String countryPhoneCode = 'countryPhoneCode';
  static const String username = 'username';
  static const String blocked = 'blocked';
  static const String blockedBy = 'blockedBy';
  static const String romanticStatus = 'romanticStatus';
  static const String dob = 'dob';
  static const String gender = 'gender';
  static const String geohash = 'geohash';
  static const String geopoint = 'geopoint';
}

class DatabaseMessageField {
  static const String msgTxt = 'msgTxt';
  static const String roomUid = 'roomUid';
  static const String url = 'url';
  static const String urlType = 'urlType';
  static const String online = 'online';
  static const String aniType = 'aniType';
}

class AnimationType {
  static const String balloons = 'balloons';
  static const String confetti = 'confetti';
  static const String spotlight = 'spotlight';
}

class RecentUserField {
  static const String userUid = 'userUid';
  static const String pinned = 'pinned';
  static const String archive = 'archive';
  static const String timestamp = 'timestamp';
  static const String isFromContact = 'isFromContact';
}

class LetterFields {
  static const String letterText = 'letterText';
  static const String username = 'username';
  static const String photoUrl = 'photoUrl';
  static const String displayName = 'displayName';
  static const String id = 'id';
  static const String timestamp = 'timestamp';
}
