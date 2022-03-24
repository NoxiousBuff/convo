import 'dart:developer';
import 'package:hint/api/hive.dart';
import 'package:hint/app/routes.dart';
import 'package:hint/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/pods/settings_pod.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/startup/startup_view.dart';
import 'package:hint/ui/views/discover/discover_viewmodel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

final CupertinoTabController mainViewTabController =
    CupertinoTabController(initialIndex: 0);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final discoverViewModel = locator<DiscoverViewModel>();

  void systemUiModeChanger() {
    final int deviceVersion =
        hiveApi.getFromHive(HiveApi.deviceInfoHiveBox, 'version') as int;
    if (deviceVersion >= 29) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      log('listening to the notification via actionStream');
      switch (receivedNotification.channelKey) {
        case NotificationChannelKeys.discoverChannel:
          mainViewTabController.index = 2;
          break;
        default:
      }
    });
    AwesomeNotifications()
        .displayedStream
        .listen((ReceivedNotification receivedNotification) {
      log('listening to the notification via displayStream');
      switch (receivedNotification.title) {
        case '${Emojis.smile_partying_face} A very happy morning!!':
          discoverViewModel.onRefresh();
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    systemUiModeChanger();
    return AnimatedBuilder(
      animation: settingsPod,
      builder: (context, child) {
        return MaterialApp(
          restorationScopeId: 'Convo',
          debugShowCheckedModeBanner: false,
          title: 'Convo',
          themeMode: settingsPod.appTheme,
          theme:
              ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xff121212),
          ),
          home: const StartUpView(),
          routes: appRoutes,
        );
      },
    );
  }
}
