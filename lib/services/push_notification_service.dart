import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_strings.dart';

final pushNotificationService = PushNotificationService();

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final log = getLogger('PushNotificationService');

  late int id;

  void askForNotificationPermission() async {
    NotificationSettings settings = await _fcm.requestPermission();
    log.wtf('User granted permission: ${settings.authorizationStatus}');
  }

  onForegroundMessage() async {
    await _fcm.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      // AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     largeIcon: message.data['imageUrl'],
      //     notificationLayout: NotificationLayout.BigText,
      //     id: id,
      //     channelKey: NotificationChannelKeys.zapChannel,
      //     title: message.data['title'],
      //     body: message.data['body'],
      //   ),
      // );
      switch (message.data['channelKey']) {
        case NotificationChannelKeys.zapChannel:
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              largeIcon: message.data['imageUrl'],
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              channelKey: NotificationChannelKeys.zapChannel,
              notificationLayout: NotificationLayout.BigText,
              title: message.data['title'],
              body: message.data['body'],
            ),
          );
          break;
        case NotificationChannelKeys.letterChannel:
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              largeIcon: message.data['imageUrl'],
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              channelKey: NotificationChannelKeys.letterChannel,
              notificationLayout: NotificationLayout.BigText,
              title: message.data['title'],
              body: message.data['body'],
            ),
          );
          break;
        default:
          {}
      }
    }).onError((e) {
      log.e(e);
    });
  }

  Future<void> sendZap(String userId,
      {Function? onComplete, Function? onError}) async {
    final userName = hiveApi.getUserData(FireUserField.username);
    // final userId = hiveApi.getUserData(FireUserField.id);
    final imageUrl = hiveApi.getUserData(FireUserField.photoUrl);
    try {
      await FirebaseFunctions.instance.httpsCallable('sendZap').call(
        <String, dynamic>{
          'title': userName,
          'body': 'wants to chat with you.',
          'userId': userId,
          'imageUrl': imageUrl,
        },
      ).then((value) {
        if (onComplete != null) onComplete();
        return;
      });
    } catch (e) {
      if (onError != null) onError();
    }
  }

  // Future<void> sendLetterNotification(String userId,
  //     {Function? onComplete, Function? onError}) async {
  //   final userName = hiveApi.getUserData(FireUserField.username);
  //   // final userId = hiveApi.getUserData(FireUserField.id);
  //   final imageUrl = hiveApi.getUserData(FireUserField.photoUrl);
  //   try {
  //     await FirebaseFunctions.instance.httpsCallable('sendLetterNotification').call(
  //       <String, dynamic>{
  //         'title': userName,
  //         'body': 'wants to chat with you.',
  //         'userId': userId,
  //         'imageUrl': imageUrl,
  //       },
  //     ).then((value) {
  //       if (onComplete != null) onComplete();
  //       return;
  //     });
  //   } catch (e) {
  //     if (onError != null) onError();
  //   }
  // }
}
