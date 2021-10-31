import 'package:appwrite/models.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/constants/appwrite_constants.dart';

class AppWriteApi {
  late Database db;
  late Account account;
  late Realtime realtime;
  static AppWriteApi? _instance;
  final Client client = Client();
  final log = getLogger('AppWriteApi');

  AppWriteApi._internal() {
    client
        .setEndpoint(AppWriteConstants.apiEndPoint)
        .setProject(AppWriteConstants.projectID);
    account = Account(client);
    db = Database(client);
    realtime = Realtime(client);
  }

  static AppWriteApi get instance {
    _instance ??= AppWriteApi._internal();
    return _instance!;
  }

  Future<bool> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await account.create(name: name, email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await account.createSession(email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await account.deleteSessions();
      return true;
    } on AppwriteException catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<User?> getUser() async {
    try {
      return await account.get();
    } on AppwriteException catch (e) {
      log.e(e.message);
      return null;
    }
  }

  // Future<Channel?> addChannel(String title) async {
  //   try {
  //     final document = await db.createDocument(
  //       collectionId: AppConstants.channelsCollection,
  //       data: {
  //         "title": title,
  //       },
  //       read: ['role:member'],
  //       write: ['role:member'],
  //     );
  //     return document.convertTo<Channel>(
  //         (data) => Channel.fromMap(Map<String, dynamic>.from(data)));
  //   } on AppwriteException catch (e) {
  //      log.e(e.message);
  //     return null;
  //   }
  // }

  RealtimeSubscription subscribe(List<String> channel) {
    return realtime.subscribe(channel);
  }

  Future createLiveChatUser({
    required String userUid,
    required String conversationId,
  }) async {
    try {
      await db.createDocument(
        collectionId: AppWriteConstants.liveChatscollectionID,
        data: {
          LiveChatField.userUid: userUid,
          LiveChatField.liveChatRoom: conversationId,
          LiveChatField.userMessage: ' ',
        },
        read: ['role:member'],
        write: ['role:member'],
      ).then((value) => log.wtf('Live Chat document created in appwrite'));
    } on AppwriteException catch (e) {
      log.e(e.message);
    }
  }

  Future updateMessage({
    required String documentId,
    required String collectionId,
    required Map<dynamic, dynamic> data,
  }) async {
    try {
      await db.updateDocument(
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } on AppwriteException catch (e) {
      log.e('updateDocument:$e');
    }
  }

  // Future<List<Channel>> getChannels() async {
  //   try {
  //     final docList =
  //         await db.listDocuments(collectionId: AppConstants.channelsCollection);
  //     return docList.convertTo<Channel>(
  //         (data) => Channel.fromMap(Map<String, dynamic>.from(data)));
  //   } on AppwriteException catch (e) {
  //      log.e(e.message);
  //     return [];
  //   }
  // }

  // Future<void> deleteChannel(Channel channel) async {
  //   try {
  //     await db.deleteDocument(
  //         collectionId: AppConstants.channelsCollection,
  //         documentId: channel.id);
  //   } on AppwriteException catch (e) {
  //      log.e(e.message);
  //   }
  // }
}
