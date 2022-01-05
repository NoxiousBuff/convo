import 'dart:ui';
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

  Future<AuthorizationStatus> askForNotificationPermission() async {
    NotificationSettings settings = await _fcm.requestPermission();
    log.wtf('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus;
  }

  createScheduledDiscoverNotifications() async {
    id = DateTime.now().microsecondsSinceEpoch.remainder(100000);
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: NotificationChannelKeys.discoverChannel,
            title: '${Emojis.smile_partying_face} A very happy morning!!',
            body:
                'Today\'s Top Picks have been changed. Interesting conversations are waiting for you, don\'t be lazy. ',
            notificationLayout: NotificationLayout.BigText,
            autoDismissible: true),
        schedule: NotificationCalendar(
          hour: 9,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true,
          timeZone: localTimeZone,
        ));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: NotificationChannelKeys.discoverChannel,
            title: 'Day has been ended...huh!!',
            body:
                'Your discover is going to change tomorrow..Check out any people you might wanna talk.',
            notificationLayout: NotificationLayout.BigText,
            autoDismissible: true),
        schedule: NotificationCalendar(
          hour: 21,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true,
          timeZone: localTimeZone,
        ));
  }

  createScheduledSecurityNotifications() async {
    id = DateTime.now().microsecondsSinceEpoch.remainder(100000);
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123456789,
            channelKey: NotificationChannelKeys.securityChannel,
            title: 'Making convo safer.',
            body: 'Don\'t worry we got it. Good to go. More secure than ever.',
            notificationLayout: NotificationLayout.BigText,
            autoDismissible: true),
        actionButtons: [
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Okay',
              autoDismissible: true,
              showInCompactView: false,
              buttonType: ActionButtonType.DisabledAction,
              color: const Color.fromRGBO(0, 132, 255, 1))
        ],
        // schedule: NotificationInterval(interval: 60, timeZone: localTimeZone, repeats: true),
        schedule: NotificationCalendar(
          weekday: 7,
          hour: 4,
          minute: 29,
          second: 0,
          millisecond: 0,
          repeats: true,
          timeZone: localTimeZone,
        ));
  }

  initialiseScheduledNotifications() async {
    createScheduledDiscoverNotifications();
    createScheduledSecurityNotifications();
  }

  onForegroundMessage() async {
    await _fcm.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      switch (message.data['channelKey']) {
        case NotificationChannelKeys.zapChannel:
          bool isZapNotificationsAllowed = hiveApi.getFromHive(
              HiveApi.appSettingsBoxName, AppSettingKeys.isZapAllowed,
              defaultValue: true);
          if (isZapNotificationsAllowed) {
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
          } else {
            log.wtf('User has stopped zap notifications');
          }
          break;
        case NotificationChannelKeys.letterChannel:
          bool isLetterNotificationsAllowed = hiveApi.getFromHive(
              HiveApi.appSettingsBoxName, AppSettingKeys.isLetterAllowed,
              defaultValue: true);
          if (isLetterNotificationsAllowed) {
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
          } else {
            log.wtf('User has stopped letters notification.');
          }
          break;
        default:
          {}
      }
    }).onError((e) {
      log.e(e);
    });
  }

  Future<void> sendZap(String userId,
      {required void Function() whenComplete, Function? onError}) async {
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
        whenComplete();
      });
    } catch (e) {
      if (onError != null) onError();
    }
  }
}
