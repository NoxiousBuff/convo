import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/app/routes.dart';
import 'package:hint/ui/views/auth/welcome/welcome_view.dart';
import 'package:hint/ui/views/home/home_view.dart';

bool isDarkTheme = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp(
      restorationScopeId: 'Dule',
      debugShowCheckedModeBanner: false,
      title: 'Dule',
      home: FirebaseAuth.instance.currentUser != null ? const HomeView() : const WelcomeView(),
      routes: appRoutes,
    );
  }
}
