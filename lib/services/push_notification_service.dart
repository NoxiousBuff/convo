import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hint/app/app_logger.dart';

final pushNotificationService = PushNotificationService();

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final log = getLogger('PushNotificationService');

  void askForNotificationPermission() async {
    NotificationSettings settings = await _fcm.requestPermission();
    log.wtf('User granted permission: ${settings.authorizationStatus}');
  }

  onForegroundMessage() async {
    FirebaseMessaging.onMessage
        .listen(((RemoteMessage message) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          log.wtf(message.notification!.title);
        }
      }).onError((e) {
        log.e(e);
      });
    }));
  }
}
