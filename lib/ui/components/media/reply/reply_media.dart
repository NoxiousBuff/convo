// ignore_for_file: avoid_print
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble_type.dart';
import 'package:hint/ui/components/media/chat_bubble/chat_bubble_border.dart';

class ReplyMedia extends StatelessWidget {
  final bool isMe;
  final FireUser fireUser;
  final String conversationId;
  final LinkedHashMap<dynamic, dynamic> replyMessage;

  const ReplyMedia(
      {Key? key,
      required this.isMe,
      required this.fireUser,
      required this.replyMessage,
      required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(4);
    //final style = Theme.of(context).textTheme.caption;
    // const mainAxisEnd = MainAxisAlignment.end;
    //const youReply = 'you replied to yourself';
    //const crossAxisEnd = CrossAxisAlignment.end;
    //const mainAxisStart = MainAxisAlignment.start;
    //const crossAxisStart = CrossAxisAlignment.start;
    //final userReply = '${fireUser.username} replied to you';
    //final maxWidth = screenWidthPercentage(context, percentage: 0.7);
    final bubbleType =
        !isMe ? BubbleType.sendBubble : BubbleType.receiverBubble;

    final textStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontSize: 12, color: black);
    // Widget replyDetector(BuildContext context) {
    //   switch (replyMessage[ReplyField.replyType]) {
    //     case MediaType.text:
    //       {
    //         return Container(
    //           constraints: BoxConstraints(maxWidth: maxWidth),
    //           child: Padding(
    //             padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
    //             child: Text(
    //               replyMessage[ReplyField.replyMessageText],
    //               maxLines: 3,
    //               softWrap: false,
    //               overflow: TextOverflow.ellipsis,
    //               style: Theme.of(context)
    //                   .textTheme
    //                   .bodyText2!
    //                   .copyWith(fontSize: 12),
    //             ),
    //           ),
    //         );
    //       }
    //     case MediaType.emoji:
    //       {
    //         final messageUid = replyMessage[ReplyField.replyMessageUid];
    //         final hiveBox = Hive.box('ImagesMemory[$conversationId]');
    //         return Container(
    //           padding: const EdgeInsets.only(bottom: 10),
    //           margin: const EdgeInsets.symmetric(horizontal: 8),
    //           constraints: const BoxConstraints(maxHeight: 60, maxWidth: 80),
    //           child: ExtendedImage(
    //             fit: BoxFit.contain,
    //             enableMemoryCache: true,
    //             handleLoadingProgress: true,
    //             image: MemoryImage(hiveBox.get(messageUid)),
    //           ),
    //         );
    //       }
    //     case MediaType.image:
    //       {
    //         return Padding(
    //           padding: const EdgeInsets.fromLTRB(4, 10, 8, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const Icon(Icons.photo, color: iconColor, size: 20),
    //               const SizedBox(width: 5),
    //               Text(
    //                 'Photo',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .bodyText2!
    //                     .copyWith(fontSize: 12),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     case MediaType.video:
    //       {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const Icon(
    //                 CupertinoIcons.videocam,
    //                 color: iconColor,
    //                 size: 20,
    //               ),
    //               const SizedBox(width: 5),
    //               Text(
    //                 'Video',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .bodyText2!
    //                     .copyWith(fontSize: 12),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     case MediaType.canvasImage:
    //       {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const Icon(CupertinoIcons.scribble,
    //                   color: iconColor, size: 20),
    //               const SizedBox(width: 5),
    //               Text(
    //                 'CanvasImage',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .bodyText2!
    //                     .copyWith(fontSize: 12),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     case MediaType.url:
    //       {
    //         return Container(
    //           constraints: BoxConstraints(maxWidth: maxWidth),
    //           child: Padding(
    //             padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
    //             child: Text(
    //               replyMessage[ReplyField.replyMessageText],
    //               maxLines: 2,
    //               softWrap: false,
    //               overflow: TextOverflow.ellipsis,
    //               style: Theme.of(context)
    //                   .textTheme
    //                   .bodyText2!
    //                   .copyWith(fontSize: 12),
    //             ),
    //           ),
    //         );
    //       }

    //     default:
    //       {
    //         return const SizedBox.shrink();
    //       }
    //   }
    // }

    // RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    //     caseSensitive: false);

    // Iterable<RegExpMatch> matches =
    //     exp.allMatches(replyMessage[ReplyField.replyMessageText]);
    // print(matches);

    // matches.forEach((match) {
    //   String messageTextURL = replyMessage!.substring(match.start, match.end);
    //   viewModel.replyMediaURLMatch(messageTextURL);
    // });

    // Widget mediaDetector(BuildContext context) {
    //   switch (replyMessage[ReplyField.replyType]) {
    //     case MediaType.text:
    //       {
    //         return const SizedBox.shrink();
    //       }
    //     case MediaType.emoji:
    //       {
    //         return const SizedBox.shrink();
    //       }
    //     case MediaType.image:
    //       {
    //         final messageUid = replyMessage[ReplyField.replyMessageUid];
    //         final hiveBox = Hive.box('ImagesMemory[$conversationId]');
    //         return Container(
    //           margin: const EdgeInsets.only(left: 16),
    //           constraints: const BoxConstraints(maxHeight: 40, maxWidth: 80),
    //           child: ExtendedImage(
    //             fit: BoxFit.contain,
    //             enableMemoryCache: true,
    //             handleLoadingProgress: true,
    //             image: MemoryImage(hiveBox.get(messageUid)),
    //           ),
    //         );
    //       }
    //     case MediaType.video:
    //       {
    //         final messageUid = replyMessage[ReplyField.replyMessageUid];
    //         final hiveBox = Hive.box('VideoThumbnails[$conversationId]');
    //         return Container(
    //           margin: const EdgeInsets.symmetric(horizontal: 8),
    //           constraints: const BoxConstraints(maxHeight: 60, maxWidth: 80),
    //           child: Stack(
    //             alignment: Alignment.center,
    //             children: [
    //               ExtendedImage(
    //                 fit: BoxFit.contain,
    //                 enableMemoryCache: true,
    //                 handleLoadingProgress: true,
    //                 image: MemoryImage(hiveBox.get(messageUid)),
    //               ),
    //               const Icon(CupertinoIcons.videocam,
    //                   color: systemBackground, size: 20)
    //             ],
    //           ),
    //         );
    //       }
    //     case MediaType.canvasImage:
    //       {
    //         final messageUid = replyMessage[ReplyField.replyMessageUid];
    //         final hiveBox = Hive.box('ImagesMemory[$conversationId]');
    //         return Container(
    //           margin: const EdgeInsets.symmetric(horizontal: 8),
    //           constraints: const BoxConstraints(maxHeight: 60, maxWidth: 80),
    //           child: ExtendedImage(
    //             fit: BoxFit.contain,
    //             enableMemoryCache: true,
    //             handleLoadingProgress: true,
    //             image: MemoryImage(hiveBox.get(messageUid)),
    //           ),
    //         );
    //       }
    //     case MediaType.url:
    //       {
    //         return const SizedBox.shrink();
    //       }

    //     default:
    //       {
    //         return const SizedBox.shrink();
    //       }
    //   }
    // }

    Widget replyWidget() {
      const senderPadding = EdgeInsets.fromLTRB(20, 10, 10, 10);
      const senderMediaPadding = EdgeInsets.fromLTRB(20, 4, 10, 4);
      const receiverPadding = EdgeInsets.fromLTRB(10, 10, 20, 10);
      const receiverMediaPadding = EdgeInsets.fromLTRB(10, 4, 20, 4);
      switch (replyMessage[ReplyField.replyType]) {
        case MediaType.text:
          {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(color: lightBlue, type: bubbleType),
                child: Padding(
                  padding: isMe ? senderPadding : receiverPadding,
                  child: Text(
                    replyMessage[ReplyField.replyMessageText],
                    maxLines: 1,
                    softWrap: false,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }
        case MediaType.url:
          {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(color: lightBlue, type: bubbleType),
                child: Padding(
                  padding: isMe ? senderPadding : receiverPadding,
                  child: Text(
                    replyMessage[ReplyField.replyMessageText],
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              ),
            );
          }
        case MediaType.image:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = hiveApi.imagesMemoryHiveBox(conversationId);
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(
                    color: lightBlue, type: bubbleType, radius: 15),
                child: Padding(
                  padding: isMe ? senderMediaPadding : receiverMediaPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: borderRadius,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: ExtendedImage(
                            fit: BoxFit.cover,
                            enableMemoryCache: true,
                            handleLoadingProgress: true,
                            image: MemoryImage(hiveBox.get(messageUid)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Photo',
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        case MediaType.video:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = hiveApi.videoThumbnailsHiveBox(conversationId);
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(
                    color: lightBlue, type: bubbleType, radius: 15),
                child: Padding(
                  padding: isMe ? senderMediaPadding : receiverMediaPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        ClipRRect(
                          borderRadius: borderRadius,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: ExtendedImage(
                              fit: BoxFit.cover,
                              enableMemoryCache: true,
                              handleLoadingProgress: true,
                              image: MemoryImage(hiveBox.get(messageUid)),
                            ),
                          ),
                        ),
                        const Icon(Icons.play_arrow,
                            color: systemBackground, size: 15),
                      ]),
                      const SizedBox(width: 10),
                      Text(
                        'Video',
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        case MediaType.meme:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = hiveApi.videoThumbnailsHiveBox(conversationId);
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(
                    color: lightBlue, type: bubbleType, radius: 15),
                child: Padding(
                  padding: isMe ? senderMediaPadding : receiverMediaPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: borderRadius,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: ExtendedImage(
                                fit: BoxFit.cover,
                                enableMemoryCache: true,
                                handleLoadingProgress: true,
                                image: MemoryImage(hiveBox.get(messageUid)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Meme',
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        case MediaType.canvasImage:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = hiveApi.imagesMemoryHiveBox(conversationId);
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(
                    color: lightBlue, type: bubbleType, radius: 15),
                child: Padding(
                  padding: isMe ? senderMediaPadding : receiverMediaPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: ExtendedImage(
                          fit: BoxFit.cover,
                          enableMemoryCache: true,
                          handleLoadingProgress: true,
                          image: MemoryImage(hiveBox.get(messageUid)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'CanvasImage',
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        case MediaType.pixaBayImage:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = hiveApi.imagesMemoryHiveBox(conversationId);
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: CustomPaint(
                painter: ChatBubbleBorder(
                    color: lightBlue, type: bubbleType, radius: 15),
                child: Padding(
                  padding: isMe ? senderMediaPadding : receiverMediaPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: ExtendedImage(
                          fit: BoxFit.cover,
                          enableMemoryCache: true,
                          handleLoadingProgress: true,
                          image: MemoryImage(hiveBox.get(messageUid)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Image',
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        default:
          {
            return const SizedBox.shrink();
          }
      }
    }

    return replyWidget();
    // GestureDetector(
    //   child: Column(
    //     crossAxisAlignment: isMe ? crossAxisEnd : crossAxisStart,
    //     children: [
    //       Row(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: isMe ? mainAxisEnd : mainAxisStart,
    //         children: [
    //           const Icon(CupertinoIcons.reply, size: 12, color: iconColor),
    //           const SizedBox(width: 5),
    //           Text(isMe ? youReply : userReply, style: style),
    //         ],
    //       ),
    //       ClipRRect(
    //         borderRadius: BorderRadius.circular(16),
    //         child: Container(
    //           color: const Color(0xfff7f7f8),
    //           constraints: BoxConstraints(maxWidth: maxWidth),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               replyDetector(context),
    //               mediaDetector(context),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
