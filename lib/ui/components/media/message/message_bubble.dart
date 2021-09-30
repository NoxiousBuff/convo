import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/hint_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:hint/ui/components/media/text/text_media.dart';
import 'package:hint/ui/components/media/video/video_media.dart';
import 'package:hint/ui/components/media/image/image_media.dart';

class MessageBubble extends StatelessWidget {
  final int index;
  final String receiverUid;
  final String conversationId;
  final HintMessage hiveMessage;
  final bool isTimestampMatched;
  final ChatViewModel chatViewModel;
  const MessageBubble({
    Key? key,
    required this.index,
    required this.hiveMessage,
    required this.receiverUid,
    required this.chatViewModel,
    required this.conversationId,
    required this.isTimestampMatched,
  }) : super(key: key);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String liveUserUid = _auth.currentUser!.uid;

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

  Widget mediaContent({
    required bool isMe,
    required String type,
  }) {
    switch (type) {
      case MediaType.image:
        {
          return ImageMedia(
            isMe: isMe,
            model: chatViewModel,
            hiveMessage: hiveMessage,
            receiverUid: receiverUid,
            conversationId: conversationId,
          );
        }
      //todo: to figure out what does this break statement do in null safety and why is it dead code
      // break;
      case MediaType.video:
        {
          final hiveBox = Hive.box('VideoThumbnails[$conversationId]');
          Uint8List? thumbnail = hiveBox.get(hiveMessage.messageUid);
          if (thumbnail != null) {
            return VideoMedia(
              isMe: isMe,
              model: chatViewModel,
              videoThumbnail: thumbnail,
              conversationId: conversationId,
              messageUid: hiveMessage.messageUid,
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      // break;
      case MediaType.text:
        {
          return TextMedia(
            isMe: isMe,
            conversationId: conversationId,
            messageText: hiveMessage.messageText,
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
    final messageDate = hiveMessage.timestamp.toDate();
    bool isMe = MessageBubble.liveUserUid == hiveMessage.senderUid;
    final date = DateFormat('yyyy-MM-dd').format(messageDate).toString();
    final mainAxis = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return OfflineBuilder(
      child: const Text("Yah!!"),
      connectivityBuilder: (context, connectivity, child) {
        // if (isMe) {
        //   if (msg.isRead && !hiveMessage.isRead) {
        //     final message = chatService.updateHiveMsg(
        //       isRead: true,
        //       isReply: hiveMessage.isReply,
        //       replyUid: hiveMessage.replyUid!,
        //       senderUid: hiveMessage.senderUid,
        //       timestamp: hiveMessage.timestamp,
        //       replyType: hiveMessage.replyType!,
        //       mediaPaths: hiveMessage.mediaPaths,
        //       messageUid: hiveMessage.messageUid,
        //       messageType: hiveMessage.messageType,
        //       messageText: hiveMessage.messageText!,
        //       replyMessage: hiveMessage.replyMessage,
        //       removeMessage: hiveMessage.removeMessage,
        //       mediaPathsType: hiveMessage.mediaPathsType,
        //     );
        //     Hive.box(conversationId).putAt(index, message);
        //   }
        // }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: mainAxis,
            crossAxisAlignment: crossAxis,
            mainAxisSize: MainAxisSize.max,
            children: [
              classifyingDate(date, context),
              // ReplyMedia(
              //     isReply: messageData.isReply,
              //     replyType: messageData.replyMessage!['replyType'],
              //     replyMsg: messageData.replyMessage!['replyMsg'],
              //     replyMsgId: messageData.replyMessage!['replyMsgId'],
              //     replyUid: messageData.replyMessage!['replyUid']),
              mediaContent(
                isMe: isMe,
                type: hiveMessage.messageType,
              ),
              isMe
                  ? hiveMessage.messageType == MediaType.text
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'unread',
                            style: GoogleFonts.roboto(
                              fontSize: 10.0,
                              color: activeBlue,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                  : const SizedBox.shrink()
            ],
          ),
        );
      },
    );
    // ViewModelBuilder<MessageBubbleViewModel>.reactive(
    //   viewModelBuilder: () => MessageBubbleViewModel(
    //     liveUserUid: liveUserUid,
    //     conversationId: conversationId,
    //     messageUid: hiveMessage.messageUid,
    //   ),
    //   builder: (context, model, child) {
    //     if (!model.dataReady) {
    //       return const Center(child: SizedBox.shrink());
    //     }
    //     if (model.hasError) {
    //       return const Text(
    //         "Ther is an error",
    //         style: TextStyle(color: systemRed),
    //       );
    //     }
    //    // final msg = NewMessage.fromFirestore(model.data!.docs[0]);
    //     return
    //   },
    // );
  }
}
