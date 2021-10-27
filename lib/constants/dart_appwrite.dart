import 'package:logger/logger.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:hint/constants/appwrite_constants.dart';

class DartAppWriteApi {
  final log = Logger();

  late Database database;
  Client client = Client();
  static DartAppWriteApi? _instance;

  DartAppWriteApi._internal() {
    client
        .setEndpoint(AppWriteConstants.apiEndPoint)
        .setProject(AppWriteConstants.projectID);
    database = Database(client);
  }

  static DartAppWriteApi get instance {
    _instance ??= DartAppWriteApi._internal();
    return _instance!;
  }

  Future createCollection() {
    return database.createCollection(
      name: 'Live Chats',
      read: ['*'],
      write: ['user:yyy', 'team:xxx'],
      rules: [
        {
          "label": "ChatRoomID",
          "key": "chatRoomId",
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
      ],
    ).catchError((e) {
      log.e('createcollection:$e');
    }).whenComplete(() => log.wtf('collection created'));
  }
}
