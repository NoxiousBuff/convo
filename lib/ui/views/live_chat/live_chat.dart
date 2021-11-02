import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/appwrite_api.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/live_chatroom.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/appwrite_list_documents.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class LiveChat extends StatefulWidget {
  final FireUser fireUser;
  final GetDocumentsList liverUserDocs;
  final GetDocumentsList receiverUserDocs;
  const LiveChat({
    Key? key,
    required this.fireUser,
    required this.liverUserDocs,
    required this.receiverUserDocs,
  }) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  late LiveChatUser _liveUser;
  LiveChatUser? _receiverUser;
  final log = getLogger('LiveChat');
  bool isLiveChatRoomIdMatched = false;
  late RealtimeSubscription subscription;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getReceiverUser();
    getLiveUser();
    final receiverUser = _receiverUser;
    if (receiverUser != null) {
      setState(() {
        subscription = AppWriteApi.instance
            .subscribe(['documents.${receiverUser.documentID}']);
      });
    } else {
      log.wtf('receiver user is null now !!');
    }
    super.initState();
  }

  LiveChatUser getLiveUser() {
    final document = widget.liverUserDocs.documents.first;
    final doc = document.cast<String, dynamic>();
    final user = LiveChatUser.fromJson(doc);

    setState(() {
      _liveUser = user;
    });
    return _liveUser;
  }

  Future getReceiverUser() async {
    final document = widget.receiverUserDocs.documents.first;
    final doc = document.cast<String, dynamic>();
    final receiverUser = LiveChatUser.fromJson(doc);

    setState(() {
      _receiverUser = receiverUser;
    });

    // String fireUserID = widget.fireUser.id;
    // final dartAppwrite = DartAppWriteApi.instance;
    // final documentsList = await dartAppwrite.getListDocuments(fireUserID);
    // final fromJsonList = GetDocumentsList.fromJson(documentsList);
    // if (fromJsonList.documents.isNotEmpty) {
    //   final receiverDocument = fromJsonList.documents.first;
    //   final mapData = receiverDocument.cast<String, dynamic>();
    //   final receiverUser = LiveChatUser.fromJson(mapData);

    //   setState(() {
    //     _receiverUser = receiverUser;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      onModelReady: (model) async {
        String fireUserId = widget.fireUser.id;
        String liveUserId = FirestoreApi.liveUserUid;
        final liveChatId =
            chatService.getConversationId(fireUserId, liveUserId);
        await model.updateMessage(
            documentId: _liveUser.documentID,
            collectionId: _liveUser.collectionID,
            data: {
              LiveChatField.userMessage: ' ',
              LiveChatField.liveChatRoom: liveChatId,
            });
      },
      onDispose: (model) {
        subscription.close;
        model.updateMessage(
            documentId: _liveUser.documentID,
            collectionId: _liveUser.collectionID,
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
                            documentId: _liveUser.documentID,
                            collectionId: _liveUser.collectionID,
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
