import 'package:firebase_database/firebase_database.dart';
import 'package:hint/app/app_logger.dart';

final realtimeDBApi = RealtimeDatabaseApi();

class RealtimeDatabaseApi {
  final log = getLogger('RealtimeDatabaseApi');
  static const realtimeDB = '/LiveChatUsers';
  final database = FirebaseDatabase.instance.reference();

 Stream<Event> documentStream(String userUid) {
   return  database.child(realtimeDB).child(userUid).onValue;
  }

  Future<void> updateUserDocument(
      String userUid, Map<String, dynamic> data) async {
    await database
        .child(realtimeDB)
        .child(userUid)
        .update(data)
        .whenComplete(() => log.wtf('User document updated in realtime db'))
        .catchError((e) {
      log.e('updateUserDocument Error:$e');
    });
  }
}
