import 'package:hint/constants/message_string.dart';
import 'package:hint/models/appwrite_list_documents.dart';
import 'package:logger/logger.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:hint/constants/appwrite_constants.dart';

class DartAppWriteApi {
  final log = Logger();

  Client client = Client();
  late Database database;
  static DartAppWriteApi? _instance;

  DartAppWriteApi._internal() {
    client
        .setEndpoint(AppWriteConstants.apiEndPoint)
        .setProject(AppWriteConstants.projectID)
        .setKey(AppWriteConstants.setKey);
    database = Database(client);
  }

  static DartAppWriteApi get instance {
    _instance ??= DartAppWriteApi._internal();
    return _instance!;
  }

  Future<Response<dynamic>> createCollection() {
    return database.createCollection(
      name: 'Live Chats',
      read: ['*'],
      write: ['*'],
      rules: [
        {
          "label": "LiveChatRoomID",
          "key": LiveChatField.liveChatRoom,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": "FirstUserID",
          "key": LiveChatField.firstUserId,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": "FirstUserMessage",
          "key": LiveChatField.firstUserMessage,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": "secondUserID",
          "key": LiveChatField.secondUserId,
          "type": "text",
          "default": "Empty Name",
          "required": true,
          "array": false
        },
        {
          "label": "SecondUserMessage",
          "key": LiveChatField.secondUserMessage,
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

  Future<bool> isLiveChatRoomExists(String liveChatRoom) async {
    final appWriteDocuments = await database.listDocuments(
      limit: 1,
      search: liveChatRoom,
      collectionId: AppWriteConstants.liveChatscollectionID,
    );
    final documentsList = GetDocumentsList.fromJson(appWriteDocuments);
    if (documentsList.documents.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<Response<dynamic>> getListDocuments(String conversationId) async {
    return database.listDocuments(
      search: conversationId,
      collectionId: AppWriteConstants.liveChatscollectionID,
    );
  }
}
