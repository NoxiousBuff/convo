import 'package:hint/app/app_logger.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseApi = DatabaseApi();

class DatabaseApi {
  final log = getLogger('DatabaseApi');

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('dules');

  Future<void> addDataWithKey(String key, Map<String, dynamic> map) async {
    try {
      await _databaseReference
          .child(key)
          .update(map)
          .then((value) => log.wtf('Successfully added the map.'));
    } catch (e) {
      log.e('There was an error in adding data : $e');
    }
  }

  Future<void> updateData(String key, Map<String, dynamic> map) async {
    try {
      await _databaseReference.child(key).update(map).then((value) => log.wtf(
          'Successfully updated the map : ${map.toString()} for key : $key'));
    } catch (e) {
      log.e('There was an error in updating data : $e');
    }
  }

  Stream<Event> getDataStream(String key) {
    return _databaseReference.child(key).onValue;
  }
}