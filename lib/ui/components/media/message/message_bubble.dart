import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/components/media/text/text_media.dart';
import 'package:hint/ui/components/media/reply/reply_media.dart';
import 'package:hint/ui/components/media/video/video_media.dart';
import 'package:hint/ui/components/media/image/image_media.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';
import 'package:hint/ui/components/media/canvas_image/canvas_image.dart';
import 'package:hint/ui/components/media/reply/reply_back_viewmodel.dart';

class MessageBubble extends StatelessWidget {
  final int index;
  final Message message;
  final FireUser fireUser;
  final String receiverUid;
  final String conversationId;
  final bool isTimestampMatched;
  final ChatViewModel chatViewModel;
  const MessageBubble({
    Key? key,
    required this.index,
    required this.fireUser,
    required this.message,
    required this.receiverUid,
    required this.chatViewModel,
    required this.conversationId,
    required this.isTimestampMatched,
  }) : super(key: key);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;

  Widget mediaContent({
    required bool isMe,
    required bool isRead,
    required String messageType,
    required MessageBubbleViewModel model,
  }) {
    switch (messageType) {
      case MediaType.image:
        {
          final hiveBox = Hive.box('ImagesMemory[$conversationId]');
          Uint8List memeoryImage = hiveBox.get(message.messageUid);
          return ImageMedia(
            message: message,
            isRead: message.isRead,
            receiverUid: receiverUid,
            memoryImage: memeoryImage,
            messageBubbleModel: model,
            conversationId: conversationId,
          );
        }
      //todo: to figure out what does this break statement do in null safety and why is it dead code
      // break;
      case MediaType.video:
        {
          final hiveBox = Hive.box('VideoThumbnails[$conversationId]');
          final thumbnail = hiveBox.get(message.messageUid);
          if (thumbnail != null) {
            return VideoMedia(
              isRead: message.isRead,
              receiverUid: receiverUid,
              messageBubbleModel: model,
              videoThumbnail: thumbnail,
              conversationId: conversationId,
              messageUid: message.messageUid,
              videoPath: message.message[MessageField.mediaURL],
            );
          } else {
            getLogger('MessageBubble').e('Thumbnail is null now');
            return const SizedBox.shrink();
          }
        }
      // break;
      case MediaType.text:
        {
          return TextMedia(
            isMe: isMe,
            isRead: isRead,
            conversationId: conversationId,
            messageText: message.message[MessageField.messageText],
          );
        }
      case MediaType.canvasImage:
        {
          final hiveBox = Hive.box('ImagesMemory[$conversationId]');
          List<int> imageData =
              hiveBox.get(message.messageUid).cast<int>().toList();
          return CanvasImage(
            message: message,
            messageBubbleModel: model,
            conversationId: conversationId,
            imageData: Uint8List.fromList(imageData),
          );
        }
      default:
        {
          return const SizedBox.shrink();
        }
      // break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final replyMessage = message.replyMessage;
    final replyRiverPod = context.read(replyBackProvider);
    final messageDate = message.timestamp.toDate();
    bool isMe = MessageBubble.liveUserUid == message.senderUid;
    final date = DateFormat('yyyy-MM-dd').format(messageDate).toString();
    final mainAxis = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return ViewModelBuilder<MessageBubbleViewModel>.reactive(
      viewModelBuilder: () => MessageBubbleViewModel(),
      builder: (context, model, child) {
        if (model.hasError) {
          getLogger('Messagebubble').e('There is an error');
        }
        return SwipeTo(
          onRightSwipe: () {
            replyRiverPod.showReplyBool(true);
            getLogger('MsgBubble').wtf('showReply: ${replyRiverPod.showReply}');
            replyRiverPod.getSwipedValue(
              isMeBool: isMe,
              fireuser: fireUser,
              swipedReply: message.isReply,
              swipedMessage: message.message,
              swipedMessageType: message.type,
              swipedTimestamp: message.timestamp,
              swipedMessageUid: message.messageUid,
            );
            getLogger('MsgBubble').wtf('Message${replyRiverPod.message}');
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: message.isReply ? 8 : 2),
            child: Column(
              mainAxisAlignment: mainAxis,
              crossAxisAlignment: crossAxis,
              mainAxisSize: MainAxisSize.max,
              children: [
                classifyingDate(date, context),
                message.isReply
                    ? ReplyMedia(
                        isMe: isMe,
                        fireUser: fireUser,
                        replyMessage: replyMessage!,
                        conversationId: conversationId)
                    : const SizedBox.shrink(),
                mediaContent(
                  isMe: isMe,
                  model: model,
                  isRead: message.isRead,
                  messageType: message.type,
                ),
                
              ],
            ),
          ),
        );
      },
    );
  }

  Widget messageRead(String read) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        read,
        style: GoogleFonts.roboto(
          fontSize: 10.0,
          color: inActiveGrey,
        ),
      ),
    );
  }

  Future<void> messageOptions(BuildContext context, String messageType) {
    Widget msgOptionTile(
        {required IconData icon,
        required String title,
        required void Function() onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: black54),
            ),
          ],
        ),
      );
    }

    Widget msgTile(String type) {
      switch (type) {
        case 'text':
          {
            return msgOptionTile(
              icon: CupertinoIcons.square_on_square,
              title: 'Copy Text',
              onTap: () {},
            );
          }
        case 'URL':
          {
            return msgOptionTile(
              icon: CupertinoIcons.square_on_square,
              title: 'Copy Text',
              onTap: () {},
            );
          }
        default:
          {
            return msgOptionTile(
              icon: CupertinoIcons.share,
              title: 'Share',
              onTap: () {},
            );
          }
      }
    }

    return showModalBottomSheet(
      elevation: 0,
      context: context,
      enableDrag: true,
      builder: (context) {
        return Material(
          elevation: 0,
          child: SizedBox(
            height: screenHeightPercentage(context, percentage: 0.1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                msgOptionTile(
                  icon: CupertinoIcons.reply_thick_solid,
                  title: 'Reply',
                  onTap: () {},
                ),
                msgTile(messageType),
                msgOptionTile(
                  icon: CupertinoIcons.forward,
                  title: 'Forward',
                  onTap: () {},
                ),
                msgOptionTile(
                  title: 'Remove',
                  icon: CupertinoIcons.delete,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget classifyingDate(String dateRead, BuildContext context) {
    return isTimestampMatched
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            width: screenWidth(context),
            child: Center(
              child: Text(
                dateRead,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
