import 'package:hint/services/chat_service.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/views/chat_list/widgets/last_message/lastmessage_viewmodel.dart';

import '../user_item.dart';

class LastMessage extends StatelessWidget {
  final FireUser fireUser;
  final Color randomColor;
  final String conversationId;
  const LastMessage({
    Key? key,
    required this.fireUser,
    required this.randomColor,
    required this.conversationId,
  }) : super(key: key);

  Widget loadingUserListItem(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      leading: ClipOval(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade300.withAlpha(30),
                Colors.indigo.shade400.withAlpha(50),
              ],
              focal: Alignment.topLeft,
              radius: 0.8,
            ),
          ),
          height: 56.0,
          width: 56.0,
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: EdgeInsets.only(
              right: screenWidthPercentage(context, percentage: 0.1)),
          decoration: BoxDecoration(
            color: Colors.indigo.shade400.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(''),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
            right: screenWidthPercentage(context, percentage: 0.4)),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
    );
  }

  String messageDate(String dateRead, DateTime lastMessageDate) {
    final dateTime = DateTime.now();
    final yesterDay = DateTime.now().subtract(const Duration(days: 1));
    final todayDate = DateFormat('yMMMMd').format(dateTime).toString();
    final yesterDayDate = DateFormat('yMMMMd').format(yesterDay).toString();
    String date() {
      if (dateRead == todayDate) {
        return DateFormat('h:mm a').format(lastMessageDate).toString();
      } else if (dateRead == yesterDayDate) {
        return 'Yesterday';
      } else {
        return dateRead;
      }
    }

    return date();
  }

  Widget messageDecider(
      BuildContext context, String type, Message lastMessage) {
    switch (type) {
      case MediaType.text:
        {
          return Text(
            lastMessage.message[MessageField.messageText],
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          );
        }

      case MediaType.url:
        {
          return Text(
            lastMessage.message[MessageField.messageText],
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          );
        }
      case MediaType.canvasImage:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.photo),
              const SizedBox(width: 5),
              Text(
                'Dickster',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      case MediaType.pixaBayImage:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.photo),
              const SizedBox(width: 5),
              Text(
                'Image',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      case MediaType.image:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.photo),
              const SizedBox(width: 5),
              Text(
                'Image',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      case MediaType.video:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.videocam_outlined),
              const SizedBox(width: 5),
              Text(
                'Video',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      case MediaType.emoji:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.sentiment_satisfied),
              const SizedBox(width: 5),
              Text(
                'Sticker',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      case MediaType.meme:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.gif_outlined),
              const SizedBox(width: 5),
              Text(
                'Gif',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        }
      default:
        {
          return const SizedBox.shrink();
        }
    }
  }

  Widget lastMessage(LastMessageViewModel model) {
    return Builder(
      builder: (context) {
        if (!model.dataReady) {
          return const SizedBox.shrink();
        }
        if (model.hasError) {
          return const SizedBox.shrink();
        }
        final data = model.data;
        if (data != null) {
          final lastDocument = data.docs.first;
          final lastMessage = Message.fromFirestore(lastDocument);
          return messageDecider(context, lastMessage.type, lastMessage);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget unreadeMessageCount(LastMessageViewModel model) {
    return Builder(
      builder: (context) {
        if (!model.dataReady) {
          return const SizedBox.shrink();
        }
        if (model.hasError) {
          return const SizedBox.shrink();
        }
        final data = model.data;
        if (data != null) {
          return model.unreadMessage != 0 ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.indigo.shade300.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(model.unreadMessage.toString()),
          ) : const SizedBox.shrink();
        }
        return const SizedBox.shrink();}
    );}

  Widget lastMessageTime(LastMessageViewModel model) {
      return Builder(
      builder: (context) {
        if (!model.dataReady) {
          return const SizedBox.shrink();
        }
        if (model.hasError) {
          return const SizedBox.shrink();
        }
        final data = model.data;
        if (data != null) {
          final lastDocument = data.docs.first;
          final lastMessage = Message.fromFirestore(lastDocument);
          final dateRead = DateFormat('yMMMMd')
              .format(lastMessage.timestamp.toDate())
              .toString();
          return Text(
            messageDate(dateRead, lastMessage.timestamp.toDate()),
            style: Theme.of(context).textTheme.caption,
          );
        }
        return const SizedBox.shrink();}
    );
    }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LastMessageViewModel>.reactive(
      viewModelBuilder: () => LastMessageViewModel(conversationId),
      onModelReady: (model) {
        model.unreadMessageLength(fireUser.id);
      },
      builder: (context, model, child) {
        return UserItem(
          fireUser: fireUser,
          onTap: () {
            chatService.startConversation(context, fireUser, randomColor);
          },
          subtitle: lastMessage(model),
          trailing: Column(
            mainAxisAlignment: model.unreadMessage != 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              lastMessageTime(model),
              unreadeMessageCount(model),
            ],
          ),
        );
      },
    );
  }
}
