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
  static const String tokens = 'tokens';
}

class DatabaseMessageField {
  static const String msgTxt = 'mT';
  static const String roomUid = 'rU';
  static const String url = 'u';
  static const String urlType = 'ut';
  static const String online = 'o';
  static const String aniType = 'aT';
}

class AnimationType {
  static const String balloons = 'balloons';
  static const String confetti = 'confetti';
  static const String hearts = 'hearts';
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
  static const String idTo = 'idTo';
  static const String idFrom = 'idFrom';
  static const String timestamp = 'timestamp';
}

class AppSettingKeys {
  static const String appTheme = 'appTheme';
  static const String phoneContact = 'phoneContact';
  static const String heartsAnimation = 'heartsAnimation';
  static const String confettiAnimation = 'confettiAnimation';
  static const String balloonsAnimation = 'balloonsAnimation';
  static const String senderBubbleColor = 'senderBubbleColor';
  static const String receiverBubbleColor = 'receiverBubbleColor';
  static const String securityNotifications = 'securityNotifications';
  static const String isTokenSaved = 'isTokenSaved';
  static const String firstListIndex = 'firstListIndex';
  static const String secondListIndex = 'secondListIndex';
  static const String todaysInterestsList = 'todaysInterestsList';
  static const String isZapAllowed = 'isZapAllowed';
  static const String isLetterAllowed = 'isLetterAllowed';
  static const String isDiscoverAllowed = 'isDiscoverAllowed';
  static const String isSecurityAllowed = 'isSecurityAllowed';
}

class AppThemes {
  static const String system = 'system';
  static const String dark = 'dark';
  static const String light = 'light';
}

class NotificationChannelKeys {
  static const String zapChannel = 'zap4_channel';
  static const String letterChannel = 'letter1_channel';
  static const String securityChannel = 'security1_channel';
  static const String discoverChannel = 'discover1_channel';
}

class NotificationChannelGroupKeys {
  static const String zapChannelGroup = 'zap_channel_group';
  static const String letterChannelGroup = 'letter_channel_group';
  static const String securityChannelGroup = 'security_channel_group';
  static const String discoverChannelGroup = 'discover_channel_group';
}