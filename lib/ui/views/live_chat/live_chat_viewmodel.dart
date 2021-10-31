import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/models/appwrite_list_documents.dart';

class LiveChatViewModel extends BaseViewModel {
  final log = getLogger('LiveChatViewModel');
  late LiveChatUser _senderLiveChatUser;
  LiveChatUser get liveChatUser => _senderLiveChatUser;

  LiveChatUser getSenderLiveChatUser(GetDocumentsList docs) {
    final document = docs.documents.first;
    final doc = document.cast<String, dynamic>();
    final user = LiveChatUser.fromJson(doc);

    _senderLiveChatUser = user;
    notifyListeners();

    return _senderLiveChatUser;
  }

  Future<dynamic> updateMessage({
    required String documentId,
    required String collectionId,
    required Map<dynamic, dynamic> data,
  }) async {
    AppWriteApi.instance.updateMessage(
      documentId: documentId,
      collectionId: collectionId,
      data: data,
    );
  }
}
