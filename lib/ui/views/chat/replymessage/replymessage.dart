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

/// This class is for displaying reply message
/// reply message are those message which is used to reply for a specific message
class ReplyMessage extends StatelessWidget {
  final String senderUid;
  final LinkedHashMap<String, dynamic> replyMessage;
  const ReplyMessage(
      {Key? key, required this.replyMessage, required this.senderUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is the color of reply stick which connect
    //The repled message to normal message
    Color replyStickColor = Theme.of(context).colorScheme.black;

    /// This widget decide the type of message
    /// After decide the type od message this will display the that message
    /// which is replied
    Widget replyMessageWidget() {
      switch (replyMessage[DocumentField.type]) {
        case MediaType.text:
          {
            /// This will widget is for text message type
            return Text(
              replyMessage[MessageField.messageText],
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontSize: 12),
            );
          }
        case MediaType.document:
          {
            /// This will display documents in reply message
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey)),
                  child: const Icon(FeatherIcons.fileText,
                      size: 16, color: Colors.white),
                ),
                horizontalSpaceTiny,
                Text(
                  replyMessage[MessageField.documentTitle],
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }
        case MediaType.image:
          {
            /// This will display image message type for replying
            final imageLocalPath = Hive.box(HiveApi.mediaHiveBox)
                .get(replyMessage[DocumentField.messageUid]);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageLocalPath == null
                    ? const Icon(FeatherIcons.image, size: 20)
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
            /// This displays the video
            final map = Hive.box(HiveApi.mediaHiveBox)
                .get(replyMessage[DocumentField.messageUid]);
            var videoThumbnailPath =
                VideoThumbnailModel.fromJson(Map.from(map)).videoThumbnailPath;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                map == null
                    ? Container(
                        height: 20,
                        width: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Center(
                            child: Icon(FeatherIcons.video, size: 10)))
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
      /// This conditions decides wether reply message will appears
      /// in right side of the screen OR left side
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// This is reply message widget which display
          /// the reply message
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
              verticalSpaceMedium,

              /// This is the reply stick which connects
              /// The replied message to normal message
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
              verticalSpaceMedium,

              /// This is the reply stick which connects
              /// The replied message to normal message
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

          /// This is reply message widget which display
          /// the reply message
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
