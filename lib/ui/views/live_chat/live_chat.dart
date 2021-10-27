import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/views/live_chat/live_chat_viewmodel.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({Key? key}) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveChatViewModel>.reactive(
      viewModelBuilder: () => LiveChatViewModel(),
      onModelReady: (model) {
        model.initialisedVariables();
        model.addMessage(data: {
          MessageField.senderUid: FirestoreApi.liveUserUid,
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
                      onChanged: (val) {},
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
