import 'dart:math';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:collection/collection.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/hint_message.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/models/new_message_model.dart';
import 'package:hint/constants/message_string.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:hint/ui/views/profile_view/profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/views/chat/chat_messages_viewmodel.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';
import 'package:hint/ui/components/media/message/message_bubble.dart';

class ChatView extends StatelessWidget {
  final FireUser fireUser;
  final Color randomColor;
  final String conversationId;
  const ChatView({
    Key? key,
    required this.fireUser,
    required this.conversationId,
    required this.randomColor,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    const dark = Brightness.dark;

    const systemUiOverlays = SystemUiOverlayStyle(
      statusBarBrightness: dark,
      statusBarIconBrightness: dark,
      systemNavigationBarDividerColor: black,
      systemNavigationBarColor: Colors.transparent,
    );
    return ViewModelBuilder<ChatViewModel>.reactive(
      onModelReady: (model) async {
        model.scrollController = ScrollController();
        // await Hive.box("ChatRoomMedia[$conversationId]").clear();
        // await Hive.box('VideoThumbnails[$conversationId]').clear();
      },
      onDispose: (model) async {
        await Hive.box(conversationId).close();
        await Hive.box("ChatRoomMedia[$conversationId]").close();
        await Hive.box('VideoThumbnails[$conversationId]').close();
      },
      builder: (context, model, child) => OfflineBuilder(
        child: const Text("Yah Baby !!"),
        connectivityBuilder: (context, connectivity, child) {
          return GestureDetector(
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
              backgroundColor: systemBackground,
              appBar: AppBar(
                elevation: 0.0,
                systemOverlayStyle: systemUiOverlays,
                //I could also use Cupertino Back Button
                leading: IconButton(
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back)),
                title: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileView(
                                  model: model,
                                  fireUser: fireUser,
                                  conversationId: conversationId))),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            fireUser.photoUrl ?? 'images/img2.jpg'),
                      ),
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
                backgroundColor: randomColor.withAlpha(60),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: ChatMessages(
                      model: model,
                      fireuser: fireUser,
                      receiverUid: fireUser.id,
                      conversationId: conversationId,
                    ),
                  ),
                  HintTextField(
                    chatViewModel: model,
                    randomColor: randomColor,
                    receiverUid: fireUser.id,
                    focusNode: model.focusNode,
                    conversationId: conversationId,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      viewModelBuilder: () =>
          ChatViewModel(conversationId: conversationId, fireUser: fireUser),
    );
  }
}

class ChatMessages extends StatelessWidget {
  final FireUser fireuser;
  final ChatViewModel model;
  final String conversationId;
  final String receiverUid;
  const ChatMessages(
      {Key? key,
      required this.model,
      required this.fireuser,
      required this.conversationId,
      required this.receiverUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatService chatService = ChatService();
    final hiveChatBox = Hive.box(conversationId);
    const padding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0);
    final hiveMessages = Hive.box(conversationId)
        .values
        .toList(growable: true)
        .reversed
        .toList();
    final groupByDate = groupBy(
      hiveMessages,
      (dynamic message) {
        final jsonMsg = message.cast<String, dynamic>();
        final msg = HintMessage.fromJson(jsonMsg);
        final DateTime messageDate = msg.timestamp.toDate();
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(messageDate).toString();
        return formattedDate;
      },
    );
    groupByDate.forEach(
      (date, list) {
        if (!model.messagesDate.contains(date)) {
          model.getMessagesDate(date);
        }
        final json = list.last.cast<String, dynamic>();
        final msg = HintMessage.fromJson(json);
        if (!model.messagesTimestamp.contains(msg.timestamp)) {
          model.getTimeStamp(msg.timestamp);
        }
      },
    );
    bool timestampMatch(HintMessage messageData) {
      final match = model.messagesTimestamp
          .any((element) => messageData.timestamp == element);
      return match;
    }

    return ViewModelBuilder<ChatMessagesViewModel>.reactive(
      viewModelBuilder: () => ChatMessagesViewModel(
          conversationId: conversationId, fireUser: fireuser),
      builder: (context, viewModel, child) {
        if (!viewModel.dataReady) {
          // getLogger('chatView|ChatMsges').wtf("No unread messages available");
        }
        if (viewModel.hasError) {
          viewModel.error(() {
            getLogger('chatView|ChatMsges Error').e(e);
          });
        }
        return OfflineBuilder(
          child: const Text('Yahh !!'),
          connectivityBuilder: (context, connectivity, child) {
            bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              final data = viewModel.data;
              if (data != null) {
                final unreadMsges = data.docs;
                for (var unreadMsg in unreadMsges) {
                  final msg = NewMessage.fromFirestore(unreadMsg);
                  getLogger('chatview').wtf('isRead:${msg.isRead}');
                  if (!msg.isRead) {
                    final textMsg = chatService.addUnreadMsg(
                      isReply: msg.isReply,
                      messageType: msg.type,
                      timestamp: msg.timestamp,
                      senderUid: msg.senderUid,
                      messageUid: msg.messageUid,
                      messageText: msg.message[MessageField.messageText],
                    );
                    Hive.box(conversationId).add(textMsg);
                    getLogger('ChatView').wtf("unreadMsg: $textMsg");
                  }
                }
              } else {
                getLogger('ChatView').wtf('no unread messages available');
              }
              model.seeMsg();
            }
            return hiveChatBox.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: Hive.box(conversationId).listenable(),
                    builder: (context, box, child) {
                      return ListView.builder(
                        reverse: true,
                        padding: padding,
                        itemCount: hiveMessages.length,
                        controller: model.scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          final message =
                              hiveMessages[i].cast<String, dynamic>();
                          HintMessage hiveMessage =
                              HintMessage.fromJson(message);

                          return MessageBubble(
                            index: i,
                            chatViewModel: model,
                            receiverUid: receiverUid,
                            hiveMessage: hiveMessage,
                            conversationId: conversationId,
                            isTimestampMatched: timestampMatch(hiveMessage),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: SizedBox(
                      child: Text(
                        'Let\'s Chat',
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
