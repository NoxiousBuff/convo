import 'package:hint/api/firestore.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/appwrite_list_documents.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';

class LiveChatViewModel extends BaseViewModel {
  final log = getLogger('LiveChatViewModel');

  late final AppwriteDocument appwriteDoc;

  AppwriteDocument document(GetDocumentsList docs) {
    final document = docs.documents.elementAt(1);
    final doc = document.cast<String, dynamic>();
    final firstUserDocument = AppwriteDocument.fromJson(doc);
    bool isMe = firstUserDocument.firstUserID == FirestoreApi.liveUserUid;
    if (isMe) {
      appwriteDoc = firstUserDocument;
      notifyListeners();
      return firstUserDocument;
    } else {
      final document = docs.documents.elementAt(2);
      final doc = document.cast<String, dynamic>();
      final secondUserDocument = AppwriteDocument.fromJson(doc);
      appwriteDoc = secondUserDocument;
      notifyListeners();
      return secondUserDocument;
    }
  }

  Future<dynamic> updateMessage({
    required String value,
    required FireUser fireUser,
    required String documentId,
    required String collectionId,
    required String conersationId,
    required AppwriteDocument document,
  }) async {
    bool isMe = document.firstUserID == FirestoreApi.liveUserUid;
    if (isMe) {
      return AppWriteApi.instance.updateMessage(
        documentId: documentId,
        collectionId: collectionId,
        data: {
          LiveChatField.liveChatRoom: conersationId,
          LiveChatField.firstUserMessage: value,
          LiveChatField.secondUserId: fireUser.id,
          LiveChatField.secondUserMessage: ' ',
        },
      );
    } else {
      return AppWriteApi.instance.updateMessage(
        documentId: documentId,
        collectionId: collectionId,
        data: {
          LiveChatField.liveChatRoom: conersationId,
          LiveChatField.secondUserMessage: value,
          LiveChatField.firstUserId: fireUser.id,
          LiveChatField.firstUserMessage: ' ',
        },
      );
    }
  }
}
