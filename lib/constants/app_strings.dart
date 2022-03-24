/// This is the class that keep track of all the fields used in the app

/// Type of Media
class MediaType {
  static const String url = 'url';
  static const String text = 'text';
  static const String image = 'image';
  static const String video = 'video';
  static const String document = 'document';
}

/// These are the string of FireUser fields
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

/// Realtime Database Strings
class DatabaseMessageField {
  static const String msgTxt = 'mT';
  static const String roomUid = 'rU';
  static const String url = 'u';
  static const String urlType = 'uT';
  static const String online = 'o';
  static const String aniType = 'aT';
}

// * This is the type of animations
class AnimationType {
  static const String hearts = 'hearts';
  static const String dollar = 'dollar';
  static const String fuckOff = 'fuckOff';
  static const String balloons = 'balloons';
  static const String confetti = 'confetti';
}

// * These are the strings of recent user field
class RecentUserField {
  static const String userUid = 'userUid';
  static const String pinned = 'pinned';
  static const String archive = 'archive';
  static const String timestamp = 'timestamp';
  static const String isFromContact = 'isFromContact';
}

/// These are the String of Letters
class LetterFields {
  static const String idTo = 'idTo';
  static const String idFrom = 'idFrom';
  static const String username = 'username';
  static const String photoUrl = 'photoUrl';
  static const String timestamp = 'timestamp';
  static const String letterText = 'letterText';
  static const String displayName = 'displayName';
}

/// App Settings Strings
class AppSettingKeys {
  static const String appTheme = 'appTheme';
  static const String phoneContact = 'phoneContact';
  static const String isTokenSaved = 'isTokenSaved';
  static const String isZapAllowed = 'isZapAllowed';
  static const String firstListIndex = 'firstListIndex';
  static const String heartsAnimation = 'heartsAnimation';
  static const String isLetterAllowed = 'isLetterAllowed';
  static const String secondListIndex = 'secondListIndex';
  static const String confettiAnimation = 'confettiAnimation';
  static const String balloonsAnimation = 'balloonsAnimation';
  static const String senderBubbleColor = 'senderBubbleColor';
  static const String isDiscoverAllowed = 'isDiscoverAllowed';
  static const String isSecurityAllowed = 'isSecurityAllowed';
  static const String receiverBubbleColor = 'receiverBubbleColor';
  static const String todaysInterestsList = 'todaysInterestsList';
  static const String securityNotifications = 'securityNotifications';
  static const String hasDiscoverNotificationScheduled =
      'hasDiscoverNotificationScheduled';
  static const String hasSecurityNotificationAllowed =
      'hasSecurityNotificationAllowed';
  static const String hasCompletedAuthentication = 'hasCompletedAuthentication';
}

/// App Theme Mode Strings
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

class DocumentField {
  static const String isRead = 'isRead';
  static const String isReply = 'isReply';
  static const String message = 'message';
  static const String messageUid = 'messageUid';
  static const String replyMessage = 'replyMessage';
  static const String senderUid = 'senderUid';
  static const String timestamp = 'timestamp';
  static const String type = 'type';
  static const String reactions = 'reactions';
}

class MessageField {
  static const String size = 'size';
  static const String mediaUrl = 'mediaUrl';
  static const String blurHash = 'blurHash';
  static const String mediaList = 'mediaList';
  static const String mediaType = 'mediaType';
  static const String messageText = 'messageText';
  static const String documentTitle = 'documentTitle';
  static const String reactedUsersID = 'reactedUsersID';
  static const String senderLocalPath = 'senderLocalPath';
  static const String senderThumbnail = 'senderThumbnail';
  static const String receiverThumbnail = 'receiverThumbnail';
  static const String receiverLocalPath = 'receiverLocalPath';
}

/// Media HiveBox Strings
class MediaHiveBoxField {
  static const taskID = 'taskID';
  static const localPath = 'localPath';
  static const thumbnailPath = 'thumbnailPath';
}

class ReactionsField {
  static const String wow = 'wow';
  static const String sad = 'sad';
  static const String haha = 'haha';
  static const String like = 'like';
  static const String love = 'love';
  static const String angry = 'angry';
}

/// String of download tasks used in flutter downloader package
class DownloadTaskField {
  static const String taskID = 'taskID';
  static const String status = 'status';
  static const String fileName = 'fileName';
  static const String progress = 'progress';
  static const String savedDirectory = 'savedDirectory';
}
