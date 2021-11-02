import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:collection/collection.dart';
import 'package:hint/models/user_model.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:hint/ui/views/profile_view/profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/components/hint/textfield/textfield.dart';
import 'package:hint/ui/components/media/message/message_bubble.dart';

// const systemUiOverlays = SystemUiOverlayStyle(
//   statusBarBrightness: dark,
//   statusBarIconBrightness: dark,
//   systemNavigationBarDividerColor: black,
//   systemNavigationBarColor: Colors.transparent,
// );
// getLogger('$systemUiOverlays');

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
    final log = getLogger('ChatView');
    final statusStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: activeGreen, fontSize: 10);
    final lastSeenStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: inactiveGray, fontSize: 10);
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () =>
          ChatViewModel(conversationId: conversationId, fireUser: fireUser),
      onModelReady: (model) async {
        model.scrollController = ScrollController();
        await model.iBlockThisUserCkecker(
            firestoreApi.getCurrentUser()!.uid, fireUser.id);
        log.wtf('iBlockThisUser:${model.iBlockThisUser}');
        await model.userBlockMeChecker(
            fireUser.id, firestoreApi.getCurrentUser()!.uid);
        log.wtf('userBlockMe:${model.userBlockMe}');
      },
      onDispose: (model) async {
        if (urlDataHiveBox(conversationId).isOpen) {
          await urlDataHiveBox(conversationId).close();
        } else if (imagesMemoryHiveBox(conversationId).isOpen) {
          await imagesMemoryHiveBox(conversationId).close();
        } else if (chatRoomMediaHiveBox(conversationId).isOpen) {
          await chatRoomMediaHiveBox(conversationId).close();
        } else if (thumbnailsPathHiveBox(conversationId).isOpen) {
          await thumbnailsPathHiveBox(conversationId).close();
        } else if (videoThumbnailsHiveBox(conversationId).isOpen) {
          await videoThumbnailsHiveBox(conversationId).close();
        }
        if (await model.hasMessage(conversationId)) {
          await chatService.addToRecentList(fireUser.id);
        }
      },
      builder: (context, model, child) {
        final url = fireUser.photoUrl ?? 'images/img2.jpg';
        return OfflineBuilder(
          child: const Text("Yah Baby !!"),
          connectivityBuilder: (context, connectivity, child) {
            bool connected = connectivity != ConnectivityResult.none;

            if (connected) {
              model.seeMsg();
            }
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
                appBar: AppBar(
                  elevation: 0.0,
                  centerTitle: true,
                  toolbarHeight: 100.0,
                  leadingWidth: 130,
                  automaticallyImplyLeading: true,
                  backgroundColor: randomColor.withAlpha(60),
                  leading: SizedBox(
                    width: 56,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, size: 20)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            cupertinoTransition(
                              enterTo: ProfileView(
                                  model: model,
                                  fireUser: fireUser,
                                  iBlockThisUser: model.iBlockThisUser,
                                  conversationId: conversationId),
                              exitFrom: ChatView(
                                fireUser: fireUser,
                                randomColor: randomColor,
                                conversationId: conversationId,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(url),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: StreamBuilder<DocumentSnapshot>(
                      stream: model.statusStream(fireUser.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String status = snapshot.data!['status'];
                          bool isOnline = snapshot.data!['status'] == 'Online';
                          var timestamp =
                              snapshot.data!['lastSeen'] as Timestamp;
                          var lastSeen = time.format(timestamp.toDate(),
                              allowFromNow: true);
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                fireUser.username,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              verticalSpaceTiny,
                              isOnline
                                  ? Text(status, style: statusStyle)
                                  : Text(lastSeen, style: lastSeenStyle)
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                  actions: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                      child: TextButton(
                        onPressed: () {
                          model.enterInLiverChat(context);
                        },
                        child: model.isBusy
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        activeBlue)),
                              )
                            : Text(
                                'Live Chat',
                                style: Theme.of(context).textTheme.caption,
                              ),
                      ),
                    )
                  ],
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
                    hintTextField(
                      model: model,
                      context: context,
                      child: HintTextField(
                        fireUser: fireUser,
                        chatViewModel: model,
                        randomColor: randomColor,
                        receiverUid: fireUser.id,
                        focusNode: model.focusNode,
                        conversationId: conversationId,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget hintTextField(
      {required Widget child,
      required ChatViewModel model,
      required BuildContext context}) {
    if (model.iBlockThisUser) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'You block ${fireUser.username} If you want to send messages. \nYou have to first unblock ${fireUser.username}',
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return child;
    }
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
