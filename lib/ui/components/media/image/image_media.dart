import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/routes/shared_axis_route.dart';
import 'package:hint/ui/components/media/image/full_image.dart';
import 'package:hint/ui/components/convo/hint_image.dart';

class ImageMedia extends StatefulWidget {
  final messageUid;
  final String? mediaUrl;
  final String? messageText;
  final Timestamp? timestamp;
  final bool? isMe;

  ImageMedia({
    required this.mediaUrl,
    required this.messageText,
    required this.messageUid,
    this.timestamp,
    this.isMe,
  });

  @override
  _ImageMediaState createState() => _ImageMediaState();
}

class _ImageMediaState extends State<ImageMedia> {
  final double circularBorderRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            widget.isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Hero(
            tag: widget.messageUid,
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.width * 0.2,
                minWidth: MediaQuery.of(context).size.width * 0.2,
                maxHeight: double.infinity,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circularBorderRadius)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(circularBorderRadius),
                //todo: I need to specify mediaUrl nullable
                child: HintImage(
                  uuid: widget.messageUid,
                  mediaUrl: widget.mediaUrl ?? '',
                  hiveBoxName: HiveHelper.hiveBoxImages,
                  folderPath: 'Hint Images',
                  onTap: () {
                    final route = SharedAxisPageRoute(
                      page: FullImage(
                        photoUrl: widget.mediaUrl,
                        messageText: widget.messageText,
                        messageUid: widget.messageUid,
                        hiveBoxName: HiveHelper.hiveBoxImages,
                      ),
                      transitionType: SharedAxisTransitionType.scaled,
                    );
                    Navigator.of(context).push(route);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
