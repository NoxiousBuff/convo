import 'package:get_it/get_it.dart';
import 'package:hint/api/database.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/pods/verify_email_pod.dart';
import 'package:hint/services/permission_service.dart';
import 'package:hint/ui/views/discover/discover_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseApi>(() => DatabaseApi());
  locator.registerLazySingleton<FirestoreApi>(() => FirestoreApi());
  locator.registerLazySingleton<HiveApi>(() => HiveApi());
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
  locator.registerLazySingleton<VerifyEmailStatus>(() => VerifyEmailStatus());
  locator.registerLazySingleton<DiscoverViewModel>(() => DiscoverViewModel());
}