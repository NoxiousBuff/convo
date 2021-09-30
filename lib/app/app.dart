import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/prototypes/phone/phone_auth_view.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        restorationScopeId: appName,
        title: appName,
        theme: ThemeData(),
        home: FirebaseAuth.instance.currentUser != null
            ? const ChatListView()
            : const PhoneAuthView(),
      );
  }
}