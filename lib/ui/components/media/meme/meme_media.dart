// ignore_for_file: avoid_print
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_widget.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/components/media/meme/meme_media_viewmodel.dart';

class MemeMedia extends StatelessWidget {
  final bool isRead;
  final Message message;
  final String messageUid;
  final String conversationId;
  MemeMedia(
      {Key? key,
      required this.messageUid,
      required this.conversationId,
      required this.isRead,
      required this.message})
      : super(key: key);

  final log = getLogger('MemeMedia');

  @override
  Widget build(BuildContext context) {
    final networkImage = message.message[MessageField.mediaURL];
    final hiveBox = chatRoomMediaHiveBox(conversationId);
    return ViewModelBuilder<MemeMediaViewModel>.reactive(
      viewModelBuilder: () => MemeMediaViewModel(),
      onModelReady: (model) async {
        if (!hiveBox.containsKey(messageUid)) {
          log.w('hive not contain this key');
          await model.downloadAndSavePath(
            messageUid: messageUid,
            conversationId: conversationId,
            mediaURL: message.message[MessageField.mediaURL],
          );
        } else {
          log.wtf('Meme is already save in hive');
        }
      },
      builder: (context, model, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: hiveBox.listenable(),
          builder: (context, box, child) {
            return mediaBubble(
              context: context,
              isRead: isRead,
              child: !videoThumbnailsHiveBox(conversationId)
                      .containsKey(messageUid)
                  ? ExtendedImage(
                      enableLoadState: true,
                      enableMemoryCache: true,
                      image: NetworkImage(networkImage))
                  : ExtendedImage(
                      enableLoadState: true,
                      enableMemoryCache: true,
                      image: MemoryImage(videoThumbnailsHiveBox(conversationId).get(messageUid))),
            );
          },
        );
      },
    );
  }
}
