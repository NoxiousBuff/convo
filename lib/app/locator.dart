import 'package:get_it/get_it.dart';
import 'package:hint/api/database.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/services/permission_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseApi>(() => DatabaseApi());
  locator.registerLazySingleton<FirestoreApi>(() => FirestoreApi());
  locator.registerLazySingleton<HiveApi>(() => HiveApi());
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
}