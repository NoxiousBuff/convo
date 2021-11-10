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
        .setProject(AppWriteConstants.projectID)
        .setSelfSigned();
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

  Future<bool> logIn({required String email, required String password}) async {
    try {
      await account.createSession(email: email, password: password);

      return true;
    } on AppwriteException catch (e) {
      log.e('AppWrite LogIn:${e.message}');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      return true;
    } on AppwriteException catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<User> getUser() async {
    final user = await account.get().catchError((e) {
      log.e('getUser:$e');
    });
    return user;
  }

  RealtimeSubscription subscribe(List<String> channel) {
    return realtime.subscribe(channel);
  }

  Future createLiveChatUser(String userUid) async {
    try {
      await db.createDocument(
        collectionId: AppWriteConstants.liveChatscollectionID,
        data: {
          LiveChatField.mediaURL: null,
          LiveChatField.mediaType: null,
          LiveChatField.userUid: userUid,
          LiveChatField.liveChatRoom: null,
          LiveChatField.userMessage: 'Hint Live Chat',
        },
        read: ['role:member'],
        write: ['role:member'],
      ).then((value) => log.wtf('Live Chat document created in appwrite'));
    } on AppwriteException catch (e) {
      log.e('createLiveChatUser:${e.message}');
    }
  }

  Future updateDocument({
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
}
