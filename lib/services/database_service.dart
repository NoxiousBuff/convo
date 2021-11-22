import 'package:hint/api/database_api.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseService = DatabaseService();

class DatabaseService {
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
    await databaseApi.updateData('/$path', {key: value});
  }

  Stream<Event> getUserData(String uid) {
    return databaseApi.getDataStream(uid);
  }
}