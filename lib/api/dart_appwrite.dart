import 'package:hint/app/app_logger.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/constants/appwrite_constants.dart';

class DartAppWriteApi {
  final log = getLogger('DartAppWriteApi');

  Client client = Client();
  late Database database;
  static DartAppWriteApi? _instance;

  DartAppWriteApi._internal() {
    client
        .setEndpoint(AppWriteConstants.apiEndPoint)
        .setProject(AppWriteConstants.projectID)
        .setKey(AppWriteConstants.setKey)
        .setSelfSigned();
    database = Database(client);
  }

  static DartAppWriteApi get instance {
    _instance ??= DartAppWriteApi._internal();
    return _instance!;
  }

  Future<Response<dynamic>> createCollection() {
    return database.createCollection(
      name: 'Users Live Chat',
      read: ['*'],
      write: ['*'],
      rules: [
        {
          "label": 'LiveChatRoomID',
          "key": LiveChatField.liveChatRoom,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": 'UserUid',
          "key": LiveChatField.userUid,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": 'UserMessage',
          "key": LiveChatField.userMessage,
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

  Future<Response<dynamic>> getListDocuments(String userUid) async {
    return database.listDocuments(
      search: userUid,
      filters: [
        'userUid=$userUid'
      ],
      collectionId: AppWriteConstants.liveChatscollectionID,
    );
  }
}
