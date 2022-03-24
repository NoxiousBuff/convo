import 'package:firebase_database/firebase_database.dart';
import 'package:hint/api/database.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';


class DatabaseService {

  final log = getLogger('DatabaseService');

  final databaseApi = locator<DatabaseApi>();

  Future<void> addUserData(String userUId) async {
    await databaseApi.addDataWithKey(userUId, {
      DatabaseMessageField.msgTxt: '',
      DatabaseMessageField.roomUid: '',
      DatabaseMessageField.url: '',
      DatabaseMessageField.urlType: '',
      DatabaseMessageField.online: true,
      DatabaseMessageField.aniType: '',
    });
  }

  Future<void> updateUserDataWithKey(String key, dynamic value) async {
    final String path = AuthService.liveUser!.uid;
    await databaseApi.updateDataWithKey('/$path', {key: value});
  }

  Future<void> updateFireUserDataWithKey(
      String fireUserId, String key, dynamic value) async {
    await databaseApi.updateDataWithKey('/$fireUserId', {key: value});
  }

  Stream<DatabaseEvent> getUserData(String uid) {
    return databaseApi.getDataStream(uid);
  }
}
