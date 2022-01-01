import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/pods/page_controller_pod.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/views/letters/letters_view.dart';
import 'package:hint/ui/views/main/main_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final log = getLogger('HomeView');
  String uid = AuthService.liveUser!.uid;

  final isTokenSaved = hiveApi.getFromHive(
      HiveApi.appSettingsBoxName, AppSettingKeys.isTokenSaved,
      defaultValue: false);

  final firestoreApi = locator<FirestoreApi>();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  DatabaseReference _databaseReference() =>
      FirebaseDatabase.instance.ref('dules/$uid/online');

  Future<void> savingUserToken() async {
    final _token = await _fcm.getToken();
    if (!isTokenSaved) firestoreApi.saveTokenToDatabase(_token);
    _fcm.onTokenRefresh.listen((token) {
      firestoreApi
          .saveTokenToDatabase(token)
          .then((value) => log.wtf('$token is saved via token refresh stream.'))
          .onError((error, stackTrace) => log.e(
              'there was error in saving the $token via token refresh stream.'));
    });
  }

  @override
  void initState() {
    super.initState();
    savingUserToken();
    final ref = _databaseReference();
    ref.set(true);
    WidgetsBinding.instance!.addObserver(this);
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
      await FirebaseDatabase.instance
          .goOnline()
          .whenComplete(() => log.wtf('Database Go Online'));
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
    return Consumer(
      builder: (BuildContext context, ref, Widget? child) {
        final pageControllerProvider = ref.watch(pageControllerPod);
        return PageView(
          controller: mainViewPageController,
          scrollBehavior: const MaterialScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          physics: pageControllerProvider.currentIndex != 0
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          children: const [
            MainView(),
            LettersView(),
          ],
        );
      },
    );
  }
}
