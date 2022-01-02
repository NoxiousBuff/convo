import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/pods/settings_pod.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void systemUiModeChanger() {
    final deviceVersion =
        hiveApi.getFromHive(HiveApi.deviceInfoHiveBox, 'version');
    final intDeviceVersion = int.parse(deviceVersion);
    if (intDeviceVersion >= 10) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().actionStream.listen(
    (ReceivedNotification receivedNotification){
      log('listening to the notification via actionStream');
    }
);
  }

  @override
  Widget build(BuildContext context) {
    systemUiModeChanger();
    return AnimatedBuilder(
      animation: settingsPod,
      builder: (context, child) {
        return MaterialApp(
          restorationScopeId: 'Dule',
          debugShowCheckedModeBanner: false,
          title: 'Dule',
          themeMode: settingsPod.appTheme,
          theme:
              ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
          darkTheme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: const Color(0xff121212)),
          home: OfflineBuilder(
            child: const Text(''),
            connectivityBuilder: (context, connection, child) {
              return FirebaseAuth.instance.currentUser != null
                  ? const HomeView()
                  : const WelcomeView();
            },
          ),
          routes: appRoutes,
        );
      },
    );
  }
}