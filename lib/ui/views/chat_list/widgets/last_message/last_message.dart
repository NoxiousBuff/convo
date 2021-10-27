import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/views/chat/unread_messages.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/views/chat_list/widgets/last_message/lastmessage_viewmodel.dart';

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

  buildChatListItemPopup({required FireUser fireUser}) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipOval(
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(fireUser.photoUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fireUser.username,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fireUser.email,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 18.0),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0x4D000000), thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.chat_bubble),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.phone),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.video_camera),
              ),
            ],
          ),
          const SizedBox(height: 16.0)
        ],
      ),
    );
  }

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
    final todayDate = DateFormat('yMd').format(dateTime).toString();
    final yesterDayDate = DateFormat('yMd').format(yesterDay).toString();
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

  Widget messageDecider(Message lastMessage, BuildContext context) {
    switch (lastMessage.type) {
      case MediaType.text:
        {
          return Text(
            lastMessage.message[MessageField.messageText],
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
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
                'CanvasImage',
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LastMessageViewModel>.reactive(
      viewModelBuilder: () => LastMessageViewModel(conversationId),
      builder: (context, model, child) {
        if (!model.dataReady) {
          return const Center(child: CircularProgressIndicator());
        }
        if (model.hasError) {
          return const Center(
            child: Text('It has Error'),
          );
        }
        final data = model.data;

        if (data != null) {
          final lastDocument = data.docs.last;
          final lastMessage = Message.fromFirestore(lastDocument);
          final dateRead = DateFormat('yMd')
              .format(lastMessage.timestamp.toDate())
              .toString();
          return ListTile(
            onTap: () {
              chatService.startConversation(context, fireUser, randomColor);
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return buildChatListItemPopup(fireUser: fireUser);
                    });
              },
              child: ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        randomColor.withAlpha(30),
                        randomColor.withAlpha(50),
                      ],
                      focal: Alignment.topLeft,
                      radius: 0.8,
                    ),
                  ),
                  height: 56.0,
                  width: 56.0,
                  child: Text(
                    fireUser.username[0].toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 22),
                  ),
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                fireUser.username,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            subtitle: messageDecider(lastMessage, context),
            trailing: SizedBox(
              height: 44,
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      messageDate(dateRead, lastMessage.timestamp.toDate()),
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: lightBlue),
                    ),
                  ),
                  const Spacer(),
                  UnReadMessages(
                      fireUserID: fireUser.id, conversationId: conversationId)
                ],
              ),
            ),
          );
        } else {
          return loadingUserListItem(context);
        }
      },
    );
  }
}
