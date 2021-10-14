import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));

    return ValueListenableBuilder<Box>(
      valueListenable: appSettings.listenable(),
      builder: (context, box, child) {
        var darkTheme = box.get(darkModeKey, defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: FirebaseAuth.instance.currentUser != null
              ? const ChatListView()
              : const EmailRegisterView(),
          themeMode: darkTheme ? ThemeMode.dark : ThemeMode.light,
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
                color: inActiveGrey,
              ),
            ),
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: systemBackground,
            iconTheme: const IconThemeData(color: black54),
            dialogBackgroundColor: extraLightBackgroundGray,
            appBarTheme: const AppBarTheme(
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
                color: inActiveGrey,
              ),
            ),
          ),
        );
      },
    );
  }
}
