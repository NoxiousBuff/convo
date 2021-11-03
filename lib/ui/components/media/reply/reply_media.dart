// ignore_for_file: avoid_print
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';

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
    final borderRadius = BorderRadius.circular(20);
    final maxWidth = screenWidthPercentage(context, percentage: 0.7);
    final decoration = BoxDecoration(color: grey, borderRadius: borderRadius);

    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);

    Widget replyWidget() {
      const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

      switch (replyMessage[ReplyField.replyType]) {
        case MediaType.text:
          {
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              constraints: BoxConstraints(maxWidth: maxWidth),
              decoration: decoration,
              child: Padding(
                padding: padding,
                child: Text(
                  replyMessage[ReplyField.replyMessageText],
                  maxLines: 1,
                  softWrap: false,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
        case MediaType.url:
          {
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
                child: Text(
                  replyMessage[ReplyField.replyMessageText],
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ),
            );
          }
        case MediaType.image:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = imagesMemoryHiveBox(conversationId);
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
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
            );
          }
        case MediaType.video:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = videoThumbnailsHiveBox(conversationId);
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
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
            );
          }
        case MediaType.meme:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = videoThumbnailsHiveBox(conversationId);
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
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
            );
          }
        case MediaType.canvasImage:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = imagesMemoryHiveBox(conversationId);
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
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
            );
          }
        case MediaType.pixaBayImage:
          {
            final messageUid = replyMessage[ReplyField.replyMessageUid];
            final hiveBox = imagesMemoryHiveBox(conversationId);
            return Container(
              decoration: decoration,
              margin: const EdgeInsets.only(bottom: 4),
              constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6),
              ),
              child: Padding(
                padding: padding,
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
            );
          }
        default:
          {
            return const SizedBox.shrink();
          }
      }
    }

    return replyWidget();
  }
}
