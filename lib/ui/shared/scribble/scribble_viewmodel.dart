
import 'package:hint/api/path.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/api/storage.dart';
import 'package:flutter/material.dart';
import 'package:blurhash/blurhash.dart';
import 'package:scribble/scribble.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';

class ScribbleViewModel extends BaseViewModel {
  ScribbleViewModel(this.fireUser);

  final FireUser fireUser;

  final log = getLogger('ChatViewModel');

  /// calling storage api
  final _storageApi = StorageApi();

  /// calling path helper api class
  final _pathHelper = PathHelper();

  Future uploadScribble(BuildContext context, ScribbleNotifier notifier) async {
    final image = await notifier.renderImage();
    final bytesData = image.buffer.asUint8List();

    const _type = MediaType.image;
    final _folder = _pathHelper.folderPathDecider(_type);

    final hash = await BlurHash.encode(image.buffer.asUint8List(), 3, 4);
    final path = _pathHelper.firestorePathGenerator(_type, 'ChatMedia');
    final downloadURL = await _storageApi.uploadByteData(bytesData, path);
    final localName = _pathHelper.localNameGenerator(_type);

    /// This will save the copy of selected file in the convo app
    /// local directory or folder
    final savedFile = await _pathHelper.saveBytesLocally(bytesData,
        mediaName: localName, folderPath: _folder, extension: 'jpeg');

    Navigator.pop(context);

    /// Add the message in firestore and
    /// return the messageUid after adding message
    final uid = await chatService.addMsgAndGetUid(
      hash: hash,
      mediaType: _type,
      downloadURL: downloadURL!,
      receiverUid: fireUser.id,
      localPath: savedFile.path,
      fileSize: bytesData.lengthInBytes,
    );

    return uid;
  }
}
