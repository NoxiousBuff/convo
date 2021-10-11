import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/models/new_message_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';
import 'package:hint/ui/components/media/message/message_bubble.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StatelessWidget {
  final FireUser fireUser;
  final String conversationId;
  final Color randomColor;
  const ChatView({
    Key? key,
    required this.fireUser,
    required this.conversationId,
    required this.randomColor,
  }) : super(key: key);

  Widget buildChatView(ChatViewModel model) {
    return Builder(builder: (context) {
      if (!model.dataReady) {
        return const Center(child: CircularProgressIndicator());
      }
      if (model.hasError) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          title: const Text(
            'Something Bad Happened',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Please try again later.',
            textAlign: TextAlign.center,
          ),
          actions: [
            CupertinoButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }

      final messages = model.data!.docs;
      return messages.isNotEmpty
          ? ListView.builder(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              controller: model.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: model.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  context: context,
                  messageData: NewMessage.fromFirestore(
                    model.data!.docs[index],
                  ),
                );
              },
            )
          : const Center(
              child: SizedBox(
                child: Text(
                  'Nothing Is Here',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      onModelReady: (model) {
        model.scrollController = ScrollController();
      },
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => GestureDetector(
        onTap: () {
          MediaQuery.of(context).viewInsets.bottom == 0
              ? model.focusNode.unfocus()
              : const Text('');
        },
        dragStartBehavior: DragStartBehavior.start,
        onVerticalDragStart: (drag) {
          MediaQuery.of(context).viewInsets.bottom == 0
              ? model.focusNode.unfocus()
              : const Text('');
        },
        child: Scaffold(
          backgroundColor: CupertinoColors.white,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
            ),
            elevation: 0.0,
            //I could also use Cupertino Back Button
            leading: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      fireUser.photoUrl ?? 'images/img2.jpg'),
                ),
                verticalSpaceTiny,
                Text(
                  fireUser.username,
                  style: GoogleFonts.openSans(
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            toolbarHeight: 70.0,
            centerTitle: true,
            backgroundColor: randomColor.withAlpha(30),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(child: buildChatView(model)),
              HintTextField(
                focusNode: model.focusNode,
                receiverUid: fireUser.id,
                randomColor: randomColor,
              ),
              Container(
                height: 15,
                width: double.infinity,
                color:
                    Color.alphaBlend(randomColor.withAlpha(20), Colors.white),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () =>
          ChatViewModel(conversationId: conversationId, fireUser: fireUser),
    );
  }
}
