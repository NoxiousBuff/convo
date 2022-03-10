import 'package:hint/api/firestore.dart';
import 'package:mime/mime.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/api/background_downloader.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DocumentMedia extends StatefulWidget {
  final Message message;
  final bool fromReceiver;
  const DocumentMedia({
    Key? key,
    required this.message,
    required this.fromReceiver,
  }) : super(key: key);

  @override
  State<DocumentMedia> createState() => _DocumentMediaState();
}

class _DocumentMediaState extends State<DocumentMedia> {
  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;
  @override
  void initState() {
    bool containPath =
        Hive.box(HiveApi.mediaHiveBox).containsKey(widget.message.messageUid);
    if (widget.message.senderUid != currentUserUid) {
      if (!containPath) generalWorker();
    }
    super.initState();
  }

  /// download the file in background and save it locally in hive database
  void generalWorker() async {
    String docName = widget.message.message[MessageField.documentTitle];
    final mime = lookupMimeType(docName);
    String docExtension = mime!.split('/').last;
    final now = DateTime.now();
    final day = now.day;
    final year = now.year;
    final month = now.month;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
    String imageName = 'CON-$uploadingDate-DOC-$uploadingTime';

    /// Download the received video and save it convo application folder
    await BackgroundDownloader().saveMediaAtPath(
      mediaName: imageName,
      extension: docExtension,
      folderPath: 'Media/Convo Documents',
      messageUid: widget.message.messageUid,
      mediaURL: widget.message.message[MessageField.mediaUrl],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        /// Check wether this key[messageUid] is exists in hive database or not
        bool hiveContainPath = box.containsKey(widget.message.messageUid);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: widget.fromReceiver
                  ? Theme.of(context).colorScheme.grey
                  : widget.message.isRead
                      ? Theme.of(context).colorScheme.blue
                      : Theme.of(context).colorScheme.blue.withAlpha(150),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey)),
                  child: hiveContainPath
                      ? const Icon(
                          FeatherIcons.fileText,
                          size: 16,
                          color: Colors.white,
                        )
                      : const Icon(
                          FeatherIcons.downloadCloud,
                          size: 16,
                          color: Colors.white,
                        ),
                ),
              ),
              horizontalSpaceSmall,
              Text(
                widget.message.message[MessageField.documentTitle],
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: widget.fromReceiver
                        ? Theme.of(context).colorScheme.black
                        : Theme.of(context).colorScheme.white),
              )
            ],
          ),
        );
      },
    );
  }
}
