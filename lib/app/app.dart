import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';

bool isDarkTheme = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;
  @override
  void initState() {
    bool darkMode = appSettings.get(darkModeKey, defaultValue: false);
    setState(() {
      isDarkTheme = darkMode;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          loggedIn = true;
        });
        user.reload();
        getLogger('MyApp').wtf('user is not null LoggedIn:$loggedIn');
        //getLogger('MyApp').wtf('email:${AuthService.liveUser!.email}');
      } else {
        setState(() {
          loggedIn = false;
        });
        getLogger('MyApp').wtf('user is null LoggedIn:$loggedIn');
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //final currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: loggedIn ? const HomeView() : const EmailRegisterView(),
    );
  }
}
