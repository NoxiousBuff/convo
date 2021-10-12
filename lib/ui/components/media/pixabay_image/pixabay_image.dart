import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_widget.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/constants/message_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/components/media/pixabay_image/pixabay_image_viewmodel.dart';

class PixaBayImage extends StatelessWidget {
  final bool isRead;
  final Message message;
  final String messageUid;
  final String conversationId;
  const PixaBayImage(
      {Key? key,
      required this.isRead,
      required this.messageUid,
      required this.message,
      required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('PixaBayImage');
    final networkImage = message.message[MessageField.mediaURL];
    var hiveBox = chatRoomMediaHiveBox(conversationId);
    return ViewModelBuilder<PixaBayImageViewModel>.reactive(
      viewModelBuilder: () => PixaBayImageViewModel(),
      onModelReady: (model) async {
        if (!hiveBox.containsKey(messageUid)) {
          log.w('PixaBayImage not save in hive');
          await model.downloadAndSavePath(
            messageUid: messageUid,
            conversationId: conversationId,
            mediaURL: message.message[MessageField.mediaURL],
          );
        } else {
          log.wtf('PixaBay Image already save in hive');
        }
      },
      builder: (context, model, child) {
        return mediaBubble(
          context: context,
          isRead: isRead,
          child: !imagesMemoryHiveBox(conversationId).containsKey(messageUid)
              ? ExtendedImage(image: NetworkImage(networkImage))
              : ExtendedImage(image: FileImage(File(hiveBox.get(messageUid)))),
        );
      },
    );
  }
}
