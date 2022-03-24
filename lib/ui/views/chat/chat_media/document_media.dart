import 'package:dio/dio.dart';
import 'package:hint/api/path.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';

class DocumentMedia extends StatefulWidget {
  final Message message;
  final bool fromReceiver;
  final String folderPath;
  const DocumentMedia({
    Key? key,
    required this.message,
    required this.folderPath,
    required this.fromReceiver,
  }) : super(key: key);

  @override
  State<DocumentMedia> createState() => _DocumentMediaState();
}

class _DocumentMediaState extends State<DocumentMedia> {
  /// Calling PathHelper API
  PathHelper pathHelper = PathHelper();

  /// calling firestoreAPI
  FirestoreApi firestoreApi = FirestoreApi();

  /// The current user Uid OR user unique ID
  String currentUserUid = FirestoreApi().getCurrentUser!.uid;
  @override
  void initState() {
    if (widget.message.senderUid != currentUserUid) {
      bool containKey =
          widget.message.message.containsKey(MessageField.receiverLocalPath);
      if (!containKey) generalWorker();
    }
    super.initState();
  }

  /// download the file in background and save it locally in hive database
  void generalWorker() async {
    final _message = widget.message;
    final _messageMap = _message.message;
    final uri = Uri.parse(_message.message[MessageField.mediaUrl]);
    final fileName = pathHelper.receivedMediaName(MediaType.document);
    String docName = widget.message.message[MessageField.documentTitle];
    final directory = pathHelper.getSavedDirecotyPath(widget.folderPath);

    final mime = lookupMimeType(docName);
    String docExtension = mime!.split('/').last;

    String savedPath = '$directory/$fileName.$docExtension';
    await Dio().downloadUri(uri, savedPath);
    final map = <String, String>{MessageField.receiverLocalPath: savedPath};
    _messageMap.addEntries(map.entries);

    await firestoreApi.updateUser(
        value: _messageMap,
        uid: currentUserUid,
        propertyName: DocumentField.message);
  }

  // void generalWorker() async {
  //   String docName = widget.message.message[MessageField.documentTitle];
  //   final mime = lookupMimeType(docName);
  //   String docExtension = mime!.split('/').last;
  //   final now = DateTime.now();
  //   final day = now.day;
  //   final year = now.year;
  //   final month = now.month;
  //   String uploadingDate = '$year$month$day';
  //   String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';
  //   String imageName = 'CON-$uploadingDate-DOC-$uploadingTime';

  //   /// Download the received video and save it convo application folder
  //   await BackgroundDownloader().saveMediaAtPath(
  //     mediaName: imageName,
  //     extension: docExtension,
  //     folderPath: 'Media/Convo Documents',
  //     messageUid: widget.message.messageUid,
  //     mediaURL: widget.message.message[MessageField.mediaUrl],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveApi.mediaHiveBox).listenable(),
      builder: (context, box, child) {
        Message _message = widget.message;

        /// Check wether this key[messageUid] is exists in hive database or not
        bool hiveContainPath = box.containsKey(widget.message.messageUid);

        /// This is the LinkedHashMap<String, dynamic> of message from firestore
        final _messageMap = _message.message;

        String path = _message.message[MessageField.receiverLocalPath];

        String senderPath = _message.message[MessageField.senderLocalPath];

        /// checking if map contain this or not
        bool containPath =
            _messageMap.containsKey(MessageField.receiverLocalPath);

        if (_message.senderUid == currentUserUid) {
          return InkWell(
            onTap: () => OpenFile.open(senderPath),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: widget.message.isRead
                      ? Theme.of(context).colorScheme.blue
                      : Theme.of(context).colorScheme.blue.withAlpha(150),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey)),
                    child: const Icon(
                      FeatherIcons.uploadCloud,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    widget.message.message[MessageField.documentTitle],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.white),
                  )
                ],
              ),
            ),
          );
        } else {
          InkWell(
            onTap: () => OpenFile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.grey,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey)),
                    child: Icon(
                      containPath
                          ? FeatherIcons.file
                          : FeatherIcons.downloadCloud,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    widget.message.message[MessageField.documentTitle],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.black),
                  )
                ],
              ),
            ),
          );
        }
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
                onTap: () => OpenFile.open(path),
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
