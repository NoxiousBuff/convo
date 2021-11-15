import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/widgets/swipe_to.dart';
import 'package:hint/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/app_strings.dart';
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
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';

class MessageBubble extends StatefulWidget {
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

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final log = getLogger('MessageBubble');

  @override
  void initState() {
    log.wtf('MessageIndex:${widget.index}');
    log.wtf('MessageUid:${widget.message.messageUid}');

    if (widget.message.type == MediaType.image) {}
    super.initState();
  }

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
          final hiveBox = imagesMemoryHiveBox(widget.conversationId);
          Uint8List memeoryImage = hiveBox.get(widget.message.messageUid);
          return ImageMedia(
            message: widget.message,
            isRead: widget.message.isRead,
            receiverUid: widget.receiverUid,
            memoryImage: memeoryImage,
            messageBubbleModel: model,
            conversationId: widget.conversationId,
          );
        }
      case MediaType.video:
        {
          final hiveBox = videoThumbnailsHiveBox(widget.conversationId);
          final thumbnail = hiveBox.get(widget.message.messageUid);
          if (thumbnail != null) {
            return VideoMedia(
              messageUid: messageUid,
              isRead: widget.message.isRead,
              receiverUid: widget.receiverUid,
              messageBubbleModel: model,
              videoThumbnail: thumbnail,
              conversationId: widget.conversationId,
              videoPath: widget.message.message[MessageField.mediaURL],
            );
          } else {
            log.e('Thumbnail is null now');
            return const SizedBox.shrink();
          }
        }
      case MediaType.meme:
        {
          return MemeMedia(
            message: widget.message,
            isRead: widget.message.isRead,
            conversationId: widget.conversationId,
            messageUid: widget.message.messageUid,
          );
        }
      // break;
      case MediaType.text:
        {
          return TextMedia(
            isMe: isMe,
            isRead: isRead,
            conversationId: widget.conversationId,
            messageText: widget.message.message[MessageField.messageText],
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
              conversationId: widget.conversationId,
              url: widget.message.message[MessageField.messageText],
            ),
          );
        }
      case MediaType.canvasImage:
        {
          final hiveBox = imagesMemoryHiveBox(widget.conversationId);
          final data = hiveBox.get(widget.message.messageUid);
          final imageData = data.cast<int>().toList();
          return CanvasImage(
            isRead: isRead,
            message: widget.message,
            messageBubbleModel: model,
            conversationId: widget.conversationId,
            imageData: Uint8List.fromList(imageData),
          );
        }
      case MediaType.pixaBayImage:
        {
          return PixaBayImage(
            isRead: isRead,
            message: widget.message,
            messageUid: messageUid,
            conversationId: widget.conversationId,
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
    bool isReply = widget.message.isReply;
    DateTime messageDate = widget.message.timestamp.toDate();
    final replyRiverPod = context.read(replyBackProvider);
    bool isMe = MessageBubble.liveUserUid == widget.message.senderUid;
    String date = DateFormat('yMMMMd').format(messageDate).toString();
    final mainAxis = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxis = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return ViewModelBuilder<MessageBubbleViewModel>.reactive(
      viewModelBuilder: () => MessageBubbleViewModel(),
      builder: (context, model, child) {
        if (model.hasError) {
          log.e('There is an error');
        }
        return Container(
          margin: EdgeInsets.symmetric(vertical: isReply ? 8 : 2),
          child: Column(
            mainAxisAlignment: mainAxis,
            crossAxisAlignment: crossAxis,
            mainAxisSize: MainAxisSize.min,
            children: [
              classifyingDate(date, context),
              !isMe && widget.message.userBlockMe
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisAlignment: mainAxis,
                      crossAxisAlignment: crossAxis,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        replyMessage(context, isMe, isReply),
                        SwipeTo(
                          onRightSwipe: () {
                            replyRiverPod.showReplyBool(true);
                            log.wtf('showReply: ${replyRiverPod.showReply}');
                            replyRiverPod.getSwipedValue(
                              isMeBool: isMe,
                              fireuser: widget.fireUser,
                              swipedReply: widget.message.isReply,
                              swipedMessage: widget.message.message,
                              swipedMessageType: widget.message.type,
                              swipedTimestamp: widget.message.timestamp,
                              swipedMessageUid: widget.message.messageUid,
                              swipedMessageSenderID: widget.message.senderUid,
                            );
                            log.wtf('Message${replyRiverPod.message}');
                          },
                          child: mediaContent(
                            isMe: isMe,
                            model: model,
                            isRead: widget.message.isRead,
                            messageType: widget.message.type,
                            messageUid: widget.message.messageUid,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget replyMessage(BuildContext context, isMe, isReply) {
    if (isMe) {
      return senderReplySign(context, isMe, isReply);
    } else {
      return receiverReplySing(context, isMe, isReply);
    }
  }

  Widget senderReplySign(BuildContext context, isMe, isReply) {
    if (isReply) {
      const radius = Radius.circular(5);
      final username = widget.fireUser.username;
      final replyMessage = widget.message.replyMessage;
      const borderSide = BorderSide(color: inactiveGray, width: 2);
      String replySenderID =
          widget.message.replyMessage![ReplyField.replySenderUid];
      bool iSend = replySenderID == ChatService.liveUserUid;
      var senderText =
          iSend ? 'you replied to yourself' : 'you replied to $username';
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Text(senderText,
                    style: Theme.of(context).textTheme.caption),
              ),
              ReplyMedia(
                  isMe: isMe,
                  fireUser: widget.fireUser,
                  replyMessage: replyMessage!,
                  conversationId: widget.conversationId),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 25),
              Container(
                height: 30,
                margin: const EdgeInsets.fromLTRB(2, 0, 0, 2),
                width: screenWidthPercentage(context, percentage: 0.08),
                decoration: const ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: radius),
                    topSide: borderSide,
                    rightSide: borderSide,
                    topRightCornerSide: borderSide,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget receiverReplySing(BuildContext context, isMe, isReply) {
    if (isReply) {
      const radius = Radius.circular(5);
      final username = widget.fireUser.username;
      final replyMessage = widget.message.replyMessage;
      const borderSide = BorderSide(color: inactiveGray, width: 2);
      String replySenderID =
          widget.message.replyMessage![ReplyField.replySenderUid];
      bool iSend = replySenderID == ChatService.liveUserUid;

      var receiverText =
          !iSend ? '$username replied himself' : '$username replied to you';
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Container(
                height: 30,
                margin: const EdgeInsets.fromLTRB(2, 0, 0, 2),
                width: screenWidthPercentage(context, percentage: 0.08),
                decoration: const ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: radius),
                    topSide: borderSide,
                    leftSide: borderSide,
                    topLeftCornerSide: borderSide,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(receiverText,
                    style: Theme.of(context).textTheme.caption),
              ),
              ReplyMedia(
                  isMe: isMe,
                  fireUser: widget.fireUser,
                  replyMessage: replyMessage!,
                  conversationId: widget.conversationId),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
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

    return widget.isTimestampMatched
        ? Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                date(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
