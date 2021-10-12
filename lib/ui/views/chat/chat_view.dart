import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:collection/collection.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/message_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:hint/ui/views/profile_view/profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';
import 'package:hint/ui/components/media/message/message_bubble.dart';

class ChatView extends StatelessWidget {
  final FireUser fireUser;
  final Color randomColor;
  final String conversationId;
  const ChatView({
    Key? key,
    required this.fireUser,
    required this.randomColor,
    required this.conversationId,
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
      onModelReady: (model) {
        model.scrollController = ScrollController();
      },
      onDispose: (model) async {
        await urlDataHiveBox(conversationId).close();
        await imagesMemoryHiveBox(conversationId).close();
        await chatRoomMediaHiveBox(conversationId).close();
        await thumbnailsPathHiveBox(conversationId).close();
        await videoThumbnailsHiveBox(conversationId).close();
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
                    fireUser: fireUser,
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
    const padding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0);
    var data = model.data;

    if (data != null) {
      final groupByDate = groupBy(
        data.docs,
        (DocumentSnapshot message) {
          final DateTime messageDate = message['timestamp'].toDate();
          final dateString =
              DateFormat('yyyy-MM-dd').format(messageDate).toString();
          return dateString;
        },
      );
      groupByDate.forEach(
        (date, list) {
          if (!model.messagesDate.contains(date)) {
            model.getMessagesDate(date);
          }
          final firstTimestamp = list.last['timestamp'] as Timestamp;

          if (!model.messagesTimestamp.contains(firstTimestamp)) {
            model.getTimeStamp(firstTimestamp);
          }
        },
      );
    }
    bool timestampMatch(Message messageData) {
      final match = model.messagesTimestamp
          .any((element) => messageData.timestamp == element);
      return match;
    }

    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () =>
          ChatViewModel(conversationId: conversationId, fireUser: fireuser),
      builder: (context, model, child) {
        var data = model.data;
        if (!model.dataReady) {
          return const Center(child: CircularProgressIndicator());
        }
        if (model.hasError) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
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
        final messages = data!.docs;
        return OfflineBuilder(
          child: const Text('Yahh !!'),
          connectivityBuilder: (context, connectivity, child) {
            return messages.isNotEmpty
                ? ListView.builder(
                    reverse: true,
                    padding: padding,
                    itemCount: messages.length,
                    controller: model.scrollController,
                    itemBuilder: (context, i) {
                      final message = Message.fromFirestore(messages[i]);
                      return MessageBubble(
                        index: i,
                        message: message,
                        fireUser: fireuser,
                        chatViewModel: model,
                        receiverUid: receiverUid,
                        conversationId: conversationId,
                        isTimestampMatched: timestampMatch(message),
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
