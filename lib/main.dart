import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'app/app.dart';

/// handler to manage all the backround notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    /// Ensuring that all the [widgets] are initialised
    WidgetsFlutterBinding.ensureInitialized();

    /// initialising [firebase-core]
    await Firebase.initializeApp();

    /// isolate for checking any background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// handling for any foreground notifications
    pushNotificationService.onForegroundMessage();

    /// seting locator for dependency injection
    setupLocator();

    /// initialising hive for flutter
    await Hive.initFlutter();

    /// initialising hive boxes for local data
    await hiveApi.initialiseHive();

    /// saving device info in hive for android edge to edge screen configurations
    await hiveApi.saveDeviceInfoInHive();

    /// The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    /// running the main isolate of the app
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
