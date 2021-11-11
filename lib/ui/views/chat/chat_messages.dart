import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/views/chat/chat_messages_viewmodel.dart';
import 'package:hint/ui/components/media/message/message_bubble/hint_message_bubble.dart';

class ChatMessages extends StatefulWidget {
  final FireUser fireuser;
  final String receiverUid;
  final String conversationId;
  const ChatMessages({
    Key? key,
    required this.fireuser,
    required this.receiverUid,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  bool timestampMatch(Message messageData, ChatMessagesViewModel model) {
    final match = model.messagesTimestamp
        .any((element) => messageData.timestamp == element);
    return match;
  }

  messagesDateTime(ChatMessagesViewModel model) {
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
  }

  @override
  void didUpdateWidget(covariant ChatMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    String iD = widget.conversationId;
    FireUser fireUser = widget.fireuser;
    ScrollController controller = ScrollController();
    const padding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0);

    return ViewModelBuilder<ChatMessagesViewModel>.reactive(
      viewModelBuilder: () => ChatMessagesViewModel(
        fireUser: fireUser,
        conversationId: iD,
      ),
      builder: (context, model, child) {
        final data = model.data;
        if (!model.dataReady) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
        if (data != null) {
          messagesDateTime(model);
          final messages = data.docs;
          return messages.isNotEmpty
              ? ListView.builder(
                  reverse: true,
                  padding: padding,
                  controller: controller,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    Message message = Message.fromFirestore(messages[i]);

                    return HintMessageBubble(
                        messageIndex: i,
                        message: message,
                        conversationId: widget.conversationId);
                  },
                )
              : const Center(
                  child: SizedBox(
                    child: Text(
                      'Let\'s Chat',
                    ),
                  ),
                );
        } else {
          return const Text('Data is null now !!');
        }
      },
    );
  }
}
