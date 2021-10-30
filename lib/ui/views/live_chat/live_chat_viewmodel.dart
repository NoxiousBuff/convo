import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/appwrite_list_documents.dart';

class LiveChatViewModel extends BaseViewModel {
  final log = getLogger('LiveChatViewModel');
  late final AppwriteDocument appwriteDoc;
  String _subscriptionDocumentId = '';

  late RealtimeMessage _data;
  RealtimeMessage get subscriptionData => _data;

  AppwriteDocument document(GetDocumentsList docs) {
    final document = docs.documents.elementAt(1);
    final doc = document.cast<String, dynamic>();
    final firstUserDocument = AppwriteDocument.fromJson(doc);
    bool isMe = firstUserDocument.firstUserID == FirestoreApi.liveUserUid;
    if (isMe) {
      // final document = docs.documents.elementAt(2);
      // final doc = document.cast<String, dynamic>();
      // final secondUserDocument = AppwriteDocument.fromJson(doc);

      appwriteDoc = firstUserDocument;
      _subscriptionDocumentId = firstUserDocument.documentID;
      notifyListeners();
      return firstUserDocument;
    } else {
      final document = docs.documents.elementAt(2);
      final doc = document.cast<String, dynamic>();
      final secondUserDocument = AppwriteDocument.fromJson(doc);
      appwriteDoc = secondUserDocument;
      _subscriptionDocumentId = secondUserDocument.documentID;
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

  StreamSubscription<RealtimeMessage> stream() {
    log.wtf('subscriptiondocumentId:$_subscriptionDocumentId');
    final subscription =
        AppWriteApi.instance.subscribe(['documents.617c19de213b5']);
    return subscription.stream.listen(
      (event) {
        _data = event;
        notifyListeners();
        log.wtf('subscriptionData: ${event.event}');
      },
      onError: (e) {
        log.e('OnError:$e');
      },
      onDone: () {
        log.wtf('OnDone: subscription done');
      },
    );
  }

  Future<void> Function() closeSubscription() {
    final subscription =
        AppWriteApi.instance.subscribe(["documents.$_subscriptionDocumentId"]);
    return subscription.close;
  }
}
