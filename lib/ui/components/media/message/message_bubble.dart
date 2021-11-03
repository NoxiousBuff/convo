import 'dart:typed_data';
import 'package:hint/api/hive.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/swipe_to.dart';
import 'package:hint/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/components/media/meme/meme_media.dart';
import 'package:hint/ui/components/media/url/url_preview.dart';
import 'package:hint/ui/components/media/text/text_media.dart';
import 'package:hint/ui/components/media/reply/reply_media.dart';
import 'package:hint/ui/components/media/video/video_media.dart';
import 'package:hint/ui/components/media/image/image_media.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';
import 'package:hint/ui/components/media/canvas_image/canvas_image.dart';
import 'package:hint/ui/components/media/reply/reply_back_viewmodel.dart';
import 'package:hint/ui/components/media/pixabay_image/pixabay_image.dart';

class MessageBubble extends StatelessWidget {
  final int index;
  final Message message;
  final FireUser fireUser;
  final String receiverUid;
  final String conversationId;
  final bool isTimestampMatched;
  final ChatViewModel chatViewModel;
  MessageBubble({
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

  final log = getLogger('MessageBubble');

  Widget mediaContent({
    required bool isMe,
    required bool isRead,
    required String messageUid,
    required String messageType,
    required MessageBubbleViewModel model,
  }) {
    switch (messageType) {
      case MediaType.image:
        {
          final hiveBox = hiveApi.imagesMemoryHiveBox(conversationId);
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
      case MediaType.video:
        {
          final hiveBox = hiveApi.videoThumbnailsHiveBox(conversationId);
          final thumbnail = hiveBox.get(message.messageUid);
          if (thumbnail != null) {
            return VideoMedia(
              messageUid: messageUid,
              isRead: message.isRead,
              receiverUid: receiverUid,
              messageBubbleModel: model,
              videoThumbnail: thumbnail,
              conversationId: conversationId,
              videoPath: message.message[MessageField.mediaURL],
            );
          } else {
            log.e('Thumbnail is null now');
            return const SizedBox.shrink();
          }
        }
      case MediaType.meme:
        {
          return MemeMedia(
            message: message,
            isRead: message.isRead,
            conversationId: conversationId,
            messageUid: message.messageUid,
          );
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
      case MediaType.url:
        {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: URLPreview(
              isMe: isMe,
              isRead: isRead,
              messageUid: messageUid,
              conversationId: conversationId,
              url: message.message[MessageField.messageText],
            ),
          );
        }
      case MediaType.canvasImage:
        {
          final hiveBox = hiveApi.imagesMemoryHiveBox(conversationId);
          final data = hiveBox.get(message.messageUid);
          final imageData = data.cast<int>().toList();
          return CanvasImage(
            isRead: isRead,
            message: message,
            messageBubbleModel: model,
            conversationId: conversationId,
            imageData: Uint8List.fromList(imageData),
          );
        }
      case MediaType.pixaBayImage:
        {
          return PixaBayImage(
            isRead: isRead,
            message: message,
            messageUid: messageUid,
            conversationId: conversationId,
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
    bool isReply = message.isReply;
    final replyMessage = message.replyMessage;
    final messageDate = message.timestamp.toDate();
    final replyRiverPod = context.read(replyBackProvider);
    bool isMe = MessageBubble.liveUserUid == message.senderUid;
    final date = DateFormat('yMMMMd').format(messageDate).toString();
    final mainAxis = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final replyAlignment = isMe ? Alignment.centerLeft : Alignment.centerRight;
    return ViewModelBuilder<MessageBubbleViewModel>.reactive(
      viewModelBuilder: () => MessageBubbleViewModel(),
      onModelReady: (model) {
        log.w('Index:$index MessageUid:${message.messageUid}');
      },
      builder: (context, model, child) {
        if (model.hasError) {
          log.e('There is an error');
        }
        return Container(
          margin: EdgeInsets.symmetric(vertical: message.isReply ? 8 : 2),
          child: Column(
            mainAxisAlignment: mainAxis,
            crossAxisAlignment: crossAxis,
            mainAxisSize: MainAxisSize.min,
            children: [
              classifyingDate(date, context),
              !isMe && message.userBlockMe
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisAlignment: mainAxis,
                      crossAxisAlignment: crossAxis,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        replyTeller(isReply, isMe, context),
                        isReply
                            ? Align(
                                alignment: replyAlignment,
                                child: ReplyMedia(
                                    isMe: isMe,
                                    fireUser: fireUser,
                                    replyMessage: replyMessage!,
                                    conversationId: conversationId),
                              )
                            : const SizedBox.shrink(),
                        Row(
                          children: [
                            SizedBox(width: isMe ? 28 : 0),
                            isMe
                                ? senderReplySign(context, isMe, isReply)
                                : const SizedBox.shrink(),
                            isMe ? const Spacer() : const SizedBox.shrink(),
                            SwipeTo(
                              onRightSwipe: () {
                                replyRiverPod.showReplyBool(true);
                                log.wtf(
                                    'showReply: ${replyRiverPod.showReply}');
                                replyRiverPod.getSwipedValue(
                                  isMeBool: isMe,
                                  fireuser: fireUser,
                                  swipedReply: message.isReply,
                                  swipedMessage: message.message,
                                  swipedMessageType: message.type,
                                  swipedTimestamp: message.timestamp,
                                  swipedMessageUid: message.messageUid,
                                  swipedMessageSenderID: message.senderUid,
                                );
                                log.wtf('Message${replyRiverPod.message}');
                              },
                              child: mediaContent(
                                isMe: isMe,
                                model: model,
                                isRead: message.isRead,
                                messageType: message.type,
                                messageUid: message.messageUid,
                              ),
                            ),
                            !isMe ? const Spacer() : Container(),
                            !isMe
                                ? receiverReplySing(context, isMe, isReply)
                                : const SizedBox.shrink(),
                            SizedBox(width: isMe ? 0 : 30),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget replyTeller(bool isReply, bool isMe, BuildContext context) {
    final username = fireUser.username;
    final replyTextAlign = isMe ? Alignment.centerLeft : Alignment.centerRight;
    if (isReply) {
      String replySenderID = message.replyMessage![ReplyField.replySenderUid];
      bool iSend = replySenderID == ChatService.liveUserUid;
      var senderText =
          iSend ? 'you replied to yourself' : 'you replied to $username';

      var receiverText =
          !iSend ? '$username replied himself' : '$username replied to you';

      return Align(
        alignment: replyTextAlign,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
          child: Text(
            isMe ? senderText : receiverText,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget senderReplySign(BuildContext context, isMe, isReply) {
    return isMe
        ? isReply
            ? Column(
                children: [
                  Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: inactiveGray),
                          bottom: BorderSide(
                              color: inactiveGray, style: BorderStyle.solid),
                        ),
                      ),
                      width: screenWidthPercentage(context, percentage: 0.14)),
                  const SizedBox(height: 20),
                ],
              )
            : const SizedBox.shrink()
        : const SizedBox.shrink();
  }

  Widget receiverReplySing(BuildContext context, isMe, isReply) {
    if (isMe) {
      return const SizedBox.shrink();
    } else {
      return isReply
          ? Column(
              children: [
                Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: inactiveGray),
                        bottom: BorderSide(
                            color: inactiveGray, style: BorderStyle.solid),
                      ),
                    ),
                    width: screenWidthPercentage(context, percentage: 0.13)),
                const SizedBox(height: 20),
              ],
            )
          : const SizedBox.shrink();
    }
  }

  Widget messageRead(String read) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        read,
        style: GoogleFonts.roboto(
          fontSize: 10.0,
          color: inactiveGray,
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
            Icon(icon, color: inactiveGray),
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
    final dateTime = DateTime.now();
    final yesterDay = DateTime.now().subtract(const Duration(days: 1));
    final todayDate = DateFormat('yMMMMd').format(dateTime).toString();
    final yesterDayDate = DateFormat('yMMMMd').format(yesterDay).toString();
    String date() {
      if (dateRead == todayDate) {
        return 'Today';
      } else if (dateRead == yesterDayDate) {
        return 'Yesterday';
      } else {
        return dateRead;
      }
    }

    return isTimestampMatched
        ? Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                const Expanded(child: Divider(color: inactiveGray)),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    date(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Divider(color: inactiveGray)),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
