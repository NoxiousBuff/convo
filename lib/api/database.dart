import 'package:firebase_database/firebase_database.dart';
import 'package:hint/app/app_logger.dart';

class DatabaseApi {
  
  /// abstraction of logger for providing logs in 
  /// the console for this particular class
  final log = getLogger('DatabaseApi');
  

  /// database reference to dules document
  final DatabaseReference _dulesRef =
      FirebaseDatabase.instance.ref().child('dules');


  /// to add the data with key in [_dulesRef]
  Future<void> addDataWithKey(String key, Map<String, dynamic> map) async {
    try {
      await _dulesRef
          .child(key)
          .update(map)
          .then((value) => log.wtf('Successfully added the map.'));
    } catch (e) {
      log.e('There was an error in adding data : $e');
    }
  }

  /// to update the data with key in [_dulesRef]
  Future<void> updateDataWithKey(String key, Map<String, dynamic> map) async {
    try {
      await _dulesRef.child(key).update(map).then((value) => log.wtf(
          'Successfully updated the map : ${map.toString()} for key : $key'));
    } catch (e) {
      log.e('There was an error in updating data : $e');
    }
  }

  /// to get the stream of a particular document from
  /// the [_dulesRef]
  Stream<DatabaseEvent> getDataStream(String key) {
    return _dulesRef.child(key).onValue;
  }
}
