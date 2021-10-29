import 'package:hint/models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
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
  final log = getLogger('LiveChat');
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      onModelReady: (model) {
        final document = model.document(widget.documentsList);
        bool isMe = document.firstUserID == FirestoreApi.liveUserUid;
        log.wtf('is first user me: $isMe');
        log.wtf('documentID:${document.documentID}');
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
                  child: const Center(
                    child: Text('Data from database'),
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
                      maxLines: 2,
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
                          value: val,
                          fireUser: widget.fireUser,
                          document: model.appwriteDoc,
                          conersationId: widget.conversationId,
                          documentId: model.appwriteDoc.documentID,
                          collectionId: model.appwriteDoc.collectionID,
                        );
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
