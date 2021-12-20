/// This is the class that keep track of all the fields used in the app

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

class FireUserField {
  static const String id = 'id';
  static const String bio = 'bio';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String country = 'country';
  static const String hashTags = 'hashTags';
  static const String photoUrl = 'photoUrl';
  static const String displayName = 'displayName';
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

class AppSettingKeys {
  static const String darkTheme = 'darkTheme';
  static const String phoneContact = 'phoneContact';
  static const String incognatedMode = 'incognatedMode';
  static const String confettiAnimation = 'confettiAnimation';
  static const String balloonsAnimation = 'balloonsAnimation';
  static const String senderBubbleColor = 'senderBubbleColor';
  static const String receiverBubbleColor = 'receiverBubbleColor';
  static const String securityNotifications = 'securityNotifications';
}