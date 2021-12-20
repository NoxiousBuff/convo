import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'app/app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationService.onForegroundMessage();
  setupLocator();
  await Hive.initFlutter();
  await hiveApi.initialiseHive();
  await hiveApi.saveDeviceInfoInHive();
  runApp(const ProviderScope(child: MyApp()));
}
