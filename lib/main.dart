import 'dart:async';
import 'app/app.dart';
import 'dart:developer';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    /// Ensuring that all the [widgets] are initialised
    WidgetsFlutterBinding.ensureInitialized();

    /// initialising [firebase-core]
    await Firebase.initializeApp();

    /// initialising hive for flutter
    await Hive.initFlutter();

    /// initialising hive boxes for local data
    await hiveApi.initialiseHive();

    /// isolate for checking any background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// handling for any foreground notifications
    pushNotificationService.onForegroundMessage();

    /// intialising awesome notifications
    intialiseAwesomeNotifications();

    /// seting locator for dependency injection
    setupLocator();

    /// saving device info in hive for android edge to edge screen configurations
    await hiveApi.saveDeviceInfoInHive();

    /// Initialise flutter downloader plugin
    await FlutterDownloader.initialize(debug: true);

    /// The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    //await Hive.box(HiveApi.mediaHiveBox).clear();

    /// running the main isolate of the app
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

/// handler to manage all the backround notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
        log('User has stopped zap notifications from background.');
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
        log('User has stopped letters notification from background.');
      }
      break;
    default:
      {}
  }
}

Future<void> intialiseAwesomeNotifications() async {
  AwesomeNotifications().initialize(
    'resource://drawable/notification_icon_xhdpi',
    [
      NotificationChannel(
        importance: NotificationImportance.High,
        channelGroupKey: NotificationChannelGroupKeys.zapChannelGroup,
        channelKey: NotificationChannelKeys.zapChannel,
        channelName: 'Zap notifications',
        channelDescription:
            'Notification channel for notifications of zapping people',
        defaultColor: Colors.white70,
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
      NotificationChannel(
        importance: NotificationImportance.High,
        channelGroupKey: NotificationChannelGroupKeys.letterChannelGroup,
        channelKey: NotificationChannelKeys.letterChannel,
        channelName: 'Letter notifications',
        channelDescription: 'Notification channel for letters.',
        defaultColor: Colors.white70,
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
      NotificationChannel(
        importance: NotificationImportance.Default,
        channelGroupKey: NotificationChannelGroupKeys.discoverChannelGroup,
        channelKey: NotificationChannelKeys.discoverChannel,
        channelName: 'Discover notifications',
        channelDescription: 'Notification channel for discover feed.',
        defaultColor: Colors.white70,
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
      NotificationChannel(
        importance: NotificationImportance.Default,
        channelGroupKey: NotificationChannelGroupKeys.securityChannelGroup,
        channelKey: NotificationChannelKeys.securityChannel,
        channelName: 'Security notifications',
        channelDescription: 'Notification channel for discover feed.',
        defaultColor: Colors.white70,
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
    ],
  );
}
