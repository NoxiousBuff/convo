import 'dart:collection';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/video_thumbnail.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';

class ReplyMessage extends StatelessWidget {
  final String senderUid;
  final LinkedHashMap<String, dynamic> replyMessage;
  const ReplyMessage(
      {Key? key, required this.replyMessage, required this.senderUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color replyStickColor = Theme.of(context).colorScheme.black;
    Widget replyMessageWidget() {
      switch (replyMessage[DocumentField.type]) {
        case MediaType.text:
          {
            return Text(
              replyMessage[MessageField.messageText],
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontSize: 12),
            );
          }
        case MediaType.url:
          {
            return Text(
              replyMessage[MessageField.messageText],
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontSize: 12),
            );
          }
        case MediaType.image:
          {
            final imageLocalPath = Hive.box(HiveApi.mediaHiveBox)
                .get(replyMessage[DocumentField.messageUid]);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageLocalPath == null
                    ? const Icon(FeatherIcons.image, size: 10)
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.file(File(imageLocalPath)),
                      ),
                horizontalSpaceTiny,
                const Text('Image'),
              ],
            );
          }
        case MediaType.video:
          {
            final map = Hive.box(HiveApi.mediaHiveBox)
                .get(replyMessage[DocumentField.messageUid]);
            var videoThumbnailPath =
                VideoThumbnailModel.fromJson(Map.from(map)).videoThumbnailPath;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                map == null
                    ? const Icon(FeatherIcons.image, size: 10)
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.file(
                              File(videoThumbnailPath),
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20,
                            ),
                          ),
                          const Icon(
                            FeatherIcons.play,
                            size: 12,
                            color: Colors.white,
                          )
                        ],
                      ),
                horizontalSpaceTiny,
                const Text('Video'),
              ],
            );
          }
        default:
          {
            return shrinkBox;
          }
      }
    }

    if (senderUid == FirestoreApi().getCurrentUser!.uid) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.grey,
                  borderRadius: BorderRadius.circular(30)),
              child: replyMessageWidget(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpaceRegular,
              Container(
                height: 20,
                width: 20,
                decoration: ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(5)),
                    topSide: BorderSide(color: replyStickColor),
                    rightSide: BorderSide(color: replyStickColor),
                    topRightCornerSide: BorderSide(color: replyStickColor),
                  ),
                ),
              ),
            ],
          ),
          horizontalSpaceSmall,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          horizontalSpaceSmall,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpaceRegular,
              Container(
                height: 20,
                width: 20,
                decoration: ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(5)),
                    topSide: BorderSide(color: replyStickColor),
                    leftSide: BorderSide(color: replyStickColor),
                    topLeftCornerSide: BorderSide(color: replyStickColor),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.grey,
                  borderRadius: BorderRadius.circular(30)),
              child: replyMessageWidget(),
            ),
          ),
        ],
      );
    }
  }
}
