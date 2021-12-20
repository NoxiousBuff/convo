import 'package:hint/api/hive.dart';
import 'package:hint/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/ui/views/auth/welcome/welcome_view.dart';

bool isDarkTheme = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final log = getLogger('MyApp');
  String uid = AuthService.liveUser!.uid;

  DatabaseReference _databaseReference() =>
      FirebaseDatabase.instance.ref('dules/$uid/online');

  @override
  void initState() {
    super.initState();
    final ref = _databaseReference();
    ref.set(true);
    WidgetsBinding.instance!.addObserver(this);
  }

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



  Future<void> goOffline() async {
    try {
      await FirebaseDatabase.instance
          .goOffline()
          .whenComplete(() => log.wtf('Database Go Offline'));
      DatabaseReference ref = _databaseReference();
      OnDisconnect onDisconnect = ref.onDisconnect();
      onDisconnect.set(false);
    } catch (e) {
      log.e('goOffline Error:$e');
    }
  }

  Future<void> goOnline() async {
    try {
      await FirebaseDatabase.instance.goOnline()  .whenComplete(() => log.wtf('Database Go Online'));
      DatabaseReference ref = _databaseReference();
      ref.set(true);
    } catch (e) {
      log.e('goonline Error:$e');
    }
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      goOnline();
    } else {
      goOffline();
    }
  }

  @override
  Widget build(BuildContext context) {
    systemUiModeChanger();

    return MaterialApp(
      restorationScopeId: 'Dule',
      debugShowCheckedModeBanner: false,
      title: 'Dule',
      home: OfflineBuilder(
        child: const Text(''),
        connectivityBuilder: (context, connection, child) {
          bool connected = connection != ConnectivityResult.none;
          if (connected) {
            log.v('User Is Online');
            return FirebaseAuth.instance.currentUser != null
                ? const HomeView()
                : const WelcomeView();
          } else {
            log.v('User Is Offline');
            return FirebaseAuth.instance.currentUser != null
                ? const HomeView()
                : const WelcomeView();
          }
        },
      ),
      routes: appRoutes,
    );
  }
}