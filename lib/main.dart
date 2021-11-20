// ignore_for_file: avoid_print

import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hive/hive.dart';
import 'app/app.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();
  await Firebase.initializeApp();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
   Hive.init(appDocPath);
  await HiveHelper().initialiseHive();
  await Hive.openBox(appSettingsBoxName)
      .whenComplete(() => print('open hive box'));
  runApp(const ProviderScope(child: MyApp()));
}
