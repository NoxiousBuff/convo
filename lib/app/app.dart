import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/recent_chats/recent_chats.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';

bool isDarkTheme = false;
bool loggedIn = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final log = getLogger('MyApp');
  @override
  void initState() {
    bool darkMode = appSettings.get(darkModeKey, defaultValue: false);
    setState(() {
      isDarkTheme = darkMode;
    });
    super.initState();
  }

  Future<bool> getUser(String documentId) async {
    final firebaseUser = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(documentId)
        .get();
    if (firebaseUser.exists) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        bool userExists = await getUser(user.uid);

        if (userExists) {
          setState(() {
            loggedIn = true;
          });
        }
      } else {
        log.wtf('user is null LoggedIn:$loggedIn');
        setState(() {
          loggedIn = false;
        });
      }
    });
    super.didChangeDependencies();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(status: "Online");
    } else {
      setStatus(status: "Offline");
    }
  }

  Future<void> setStatus({required String status}) async {
    await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(FirestoreApi.liveUserUid)
        .update({
      UserField.status: status,
      UserField.lastSeen: Timestamp.now(),
    }).catchError((e) {
      log.e(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? const RecentChats() : const EmailRegisterView(),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: black,
        dialogBackgroundColor: darkModeColor,
        iconTheme: const IconThemeData(color: systemBackground),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: systemBackground),
        ),
        dialogTheme: DialogTheme(
            backgroundColor: darkModeColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        textTheme: TextTheme(
          headline5: GoogleFonts.roboto(
            fontSize: 20,
            color: systemBackground,
          ),
          headline6: GoogleFonts.roboto(
            fontSize: 18,
            color: systemBackground,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: GoogleFonts.roboto(
            fontSize: 16,
            color: systemBackground,
          ),
          bodyText2: GoogleFonts.roboto(
            fontSize: 14,
            color: systemBackground,
          ),
          caption: GoogleFonts.roboto(
            fontSize: 12,
            color: inactiveGray,
          ),
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: systemBackground,
        iconTheme: const IconThemeData(color: black54),
        dialogBackgroundColor: extraLightBackgroundGray,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: black54),
        ),
        dialogTheme: DialogTheme(
            backgroundColor: extraLightBackgroundGray,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        textTheme: TextTheme(
          headline5: GoogleFonts.roboto(
            fontSize: 20,
            color: darkModeColor,
          ),
          headline6: GoogleFonts.roboto(
            fontSize: 18,
            color: darkModeColor,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: GoogleFonts.roboto(
            fontSize: 16,
            color: darkModeColor,
          ),
          bodyText2: GoogleFonts.roboto(
            fontSize: 14,
            height: 1.2,
            color: darkModeColor,
          ),
          caption: GoogleFonts.roboto(
            fontSize: 12,
            color: inactiveGray,
          ),
        ),
      ),
    );
  }
}
