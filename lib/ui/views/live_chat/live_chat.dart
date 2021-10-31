import 'package:hint/api/dart_appwrite.dart';
import 'package:hint/api/firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/appwrite_list_documents.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class LiveChat extends StatefulWidget {
  final FireUser fireUser;
  final String conversationId;
  final GetDocumentsList documentsList;
  const LiveChat({
    Key? key,
    required this.documentsList,
    required this.conversationId,
    required this.fireUser,
  }) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  late LiveChatUser _receiverLiveChatUser;
  final log = getLogger('LiveChat');
  late RealtimeSubscription subscription;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getReceiverLiveChatUser(widget.documentsList);
    setState(() {
      subscription = AppWriteApi.instance
          .subscribe(['documents.${_receiverLiveChatUser.documentID}']);
    });
    super.initState();
  }

  LiveChatUser getReceiverLiveChatUser(GetDocumentsList docs) {
    final document = docs.documents.first;
    final doc = document.cast<String, dynamic>();
    final user = LiveChatUser.fromJson(doc);

    setState(() {
      _receiverLiveChatUser = user;
    });
    return _receiverLiveChatUser;
  }

  Future getSenderLiveChatUser(GetDocumentsList list) async {
    final liverUserId = FirestoreApi.kDefaultPhotoUrl;
    final dartAppwrite = DartAppWriteApi.instance;
    var chats = await dartAppwrite.getListDocuments(liverUserId);
    var liveChatsList = GetDocumentsList.fromJson(chats);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      onModelReady: (model) {
        model.updateMessage(
            documentId: _receiverLiveChatUser.documentID,
            collectionId: _receiverLiveChatUser.collectionID,
            data: {
              LiveChatField.userMessage: ' ',
              LiveChatField.liveChatRoom: widget.conversationId,
            });
        model.getSenderLiveChatUser(widget.documentsList);
      },
      onDispose: (model) {
        subscription.close;
        model.updateMessage(
            documentId: _receiverLiveChatUser.documentID,
            collectionId: _receiverLiveChatUser.collectionID,
            data: {
              LiveChatField.userMessage: ' ',
              LiveChatField.liveChatRoom: 'null',
            });
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(minHeight: 30),
                  margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  decoration: BoxDecoration(
                      color: CupertinoColors.extraLightBackgroundGray,
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: StreamBuilder<RealtimeMessage>(
                      stream: subscription.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('snapshot has no data');
                        }
                        final data = snapshot.data;
                        if (data != null) {
                          final liveChatUser =
                              LiveChatUser.fromJson(data.payload);
                          return Text(
                            liveChatUser.userMessage,
                            maxLines:
                                liveChatUser.userMessage.length > 100 ? 6 : 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          );
                        } else {
                          return const Text('Data is null now');
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(minHeight: 30),
                  decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  child: Center(
                    child: CupertinoTextField(
                      maxLines: controller.text.length > 100 ? 6 : 2,
                      textAlign: TextAlign.center,
                      cursorColor: CupertinoColors.systemBackground,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        color: CupertinoColors.systemBackground,
                      ),
                      controller: controller,
                      onChanged: (val) {
                        model.updateMessage(
                            documentId: _receiverLiveChatUser.documentID,
                            collectionId: _receiverLiveChatUser.collectionID,
                            data: {
                              LiveChatField.userMessage: val,
                            });
                      },
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
