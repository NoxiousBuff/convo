// ignore_for_file: avoid_print
import 'reply_back_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/constants/message_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyKeyboard extends ConsumerWidget {
  final bool isMe;
  final FireUser fireUser;
  final String conversationId;
  const ReplyKeyboard(
      {Key? key,
      required this.isMe,
      required this.fireUser,
      required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final replyPod = watch(replyBackProvider);
    var message = replyPod.message;
    final replyStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontSize: 12);
    final style = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontSize: 12);

    // RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    //     caseSensitive: false);

    // Iterable<RegExpMatch> matches =
    //     exp.allMatches(replyPod.message![MessageField.messageText]);
    // print(matches);

    Widget replyDetector() {
      switch (replyPod.messageType) {
        case MediaType.text:
          {
            if (message != null) {
              return SizedBox(
                width: 200,
                child: Text(
                  message[MessageField.messageText],
                  maxLines: 2,
                  softWrap: false,
                  style: replyStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        case MediaType.emoji:
          {
            if (message != null) {
              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 50,
                ),
                child: ExtendedImage(
                  image: NetworkImage(message[MessageField.mediaURL]),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        case MediaType.image:
          {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.photo),
                const SizedBox(width: 10),
                Text(
                  MediaType.image,
                  style: replyStyle,
                ),
              ],
            );
          }
        case MediaType.pixaBayImage:
          {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.photo),
                const SizedBox(width: 10),
                Text(
                  MediaType.image,
                  style: replyStyle,
                ),
              ],
            );
          }
        case MediaType.meme:
          {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.memories),
                const SizedBox(width: 10),
                Text(
                  MediaType.meme,
                  style: replyStyle,
                ),
              ],
            );
          }
        case MediaType.video:
          {
            return Text(
              MediaType.video,
              style: replyStyle,
            );
          }
        case MediaType.canvasImage:
          {
            return Text(
              MediaType.canvasImage,
              style: replyStyle,
            );
          }
        case MediaType.url:
          {
            if (message != null) {
              return SizedBox(
                width: 300,
                child: Text(
                  message[MessageField.messageText],
                  maxLines: 2,
                  softWrap: false,
                  style: replyStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

        default:
          {
            return const SizedBox.shrink();
          }
      }
    }

    Widget mediaDetector() {
      switch (replyPod.messageType) {
        case MediaType.image:
          {
            var messageUid = replyPod.messageUid;
            final hiveBox = imagesMemoryHiveBox(conversationId);
            final memoryImage = hiveBox.get(messageUid);
            return memoryImage != null
                ? Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(top: 8),
                    child: ExtendedImage(image: MemoryImage(memoryImage)))
                : const SizedBox.shrink();
          }
        case MediaType.meme:
          {
            var messageUid = replyPod.messageUid;
            final hiveBox = videoThumbnailsHiveBox(conversationId);
            final memoryImage = hiveBox.get(messageUid);
            return memoryImage != null
                ? Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(top: 8),
                    child: ExtendedImage(image: MemoryImage(memoryImage)))
                : const SizedBox.shrink();
          }
        case MediaType.pixaBayImage:
          {
            var messageUid = replyPod.messageUid;
            final hiveBox = imagesMemoryHiveBox(conversationId);
            final memoryImage = hiveBox.get(messageUid);
            return memoryImage != null
                ? Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(top: 8),
                    child: ExtendedImage(image: MemoryImage(memoryImage)))
                : const SizedBox.shrink();
          }
        case MediaType.video:
          {
            var messageUid = replyPod.messageUid;
            final hiveBox = videoThumbnailsHiveBox(conversationId);
            final videoThumbnail = hiveBox.get(messageUid);
            return videoThumbnail != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: ExtendedImage(
                              image: MemoryImage(videoThumbnail))),
                      const Icon(CupertinoIcons.videocam,
                          color: systemBackground, size: 20),
                    ],
                  )
                : const SizedBox.shrink();
          }
        case MediaType.canvasImage:
          {
            var messageUid = replyPod.messageUid;
            final hiveBox = imagesMemoryHiveBox(conversationId);
            return Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(top: 8),
              child: ExtendedImage(image: MemoryImage(hiveBox.get(messageUid))),
            );
          }

        default:
          {
            return const SizedBox.shrink();
          }
      }
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 80),
      width: screenWidth(context),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMe
                      ? 'Replying to yourself '
                      : 'Replying to ${fireUser.username}',
                  style: style,
                ),
                const SizedBox(height: 4),
                replyDetector(),
                const SizedBox(height: 6),
              ],
            ),
          ),
          const Spacer(),
          mediaDetector(),
          GestureDetector(
            onTap: () {
              replyPod.showReplyBool(false);
              getLogger('ReplyKeyboard')
                  .wtf('showReply: ${replyPod.showReply}');
              replyPod.removeSwipeValue();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const CircleAvatar(
                maxRadius: 14,
                backgroundColor: dirtyWhite,
                child: Icon(
                  CupertinoIcons.clear,
                  size: 16,
                  color: inactiveGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
