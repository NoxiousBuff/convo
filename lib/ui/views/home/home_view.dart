import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
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

  final _ref = FirebaseDatabase.instance
      .ref('dules/${AuthService.liveUser!.uid}/${DatabaseMessageField.online}');

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

  void goOffline() async {
    FirebaseDatabase.instance.goOffline().then((value) {
      OnDisconnect onDisconnect = _ref.onDisconnect();
      onDisconnect
          .set(false)
          .then((value) => log.wtf('Finally gone offline'))
          .catchError((e) => log.e('Getting Error:$e'));
    });
  }

  void goOnline() async {
    FirebaseDatabase.instance.goOnline().then((value) {
      _ref.set(true).then((value) => log.wtf('User is online now!!'));
    }).catchError((e) {
      log.e('goOnlineError:$e');
    });
  }

  @override
  void initState() {
    super.initState();
    savingUserToken();
    goOnline();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log.v('App Is In Foreground');

      goOnline();
    } else {
      log.v('App Is In Background');

      goOffline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
        child: const Text('data'),
        connectivityBuilder: (context, connection, child) {
          bool connected = connection != ConnectivityResult.none;
          connected ? goOnline() : goOffline();
          return Consumer(
            builder: (BuildContext context, ref, Widget? child) {
              final pageControllerProvider = ref.watch(pageControllerPod);
              return PageView(
                controller: mainViewPageController,
                scrollBehavior: const MaterialScrollBehavior(
                    androidOverscrollIndicator:
                        AndroidOverscrollIndicator.stretch),
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
        });
  }
}
