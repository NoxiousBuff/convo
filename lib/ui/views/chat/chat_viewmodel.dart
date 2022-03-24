import 'dart:io';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:blurhash/blurhash.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/path_finder.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/api/replymessage_value.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gmo_media_picker/media_picker.dart';
import 'package:hint/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:video_compress_ds/video_compress_ds.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatViewModel extends BaseViewModel {
  ChatViewModel({required this.conversationId, required this.fireUser});

  /// This is the fireuser of
  /// OR the receiver who recive our message od or media or data which will I send
  FireUser fireUser;

  /// Unique Id of a conversation
  /// without this id nobody can enter or get the conversation
  String conversationId;

  /// calling database API class
  final databaseService = DatabaseService();

  final log = getLogger('ChatViewModel');
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  /// Collection of conversation
  /// conversation means when two user chat in a chatroom this will called conversation
  /// All conversation will appear in conversation collection in firestore
  static final CollectionReference _conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  /// This is the uploading progress of file
  /// which will upload into firebase storage
  double? _uploadingFileProgress;
  double? get fileProgress => _uploadingFileProgress;

  /// Title of currently uploading file
  String _uploadingFileTitle = '';
  String get fileTitle => _uploadingFileTitle;

  /// get the title of the currently uploading file in firebasestorage
  void changeTitle(String title) {
    _uploadingFileTitle = title;
    notifyListeners();
  }

  /// Reset the current progress of file after uploading
  void updateProgress(double? value) {
    _uploadingFileProgress = value;
    notifyListeners();
  }

  /// get a hash of blurhash
  Future<String> _blurHashString(File file) async {
    final bytes = await file.readAsBytes();
    final hash = await BlurHash.encode(bytes, 4, 3);
    log.wtf('blurHash:$hash');
    return hash;
  }

  /// pick documents and return the list of string
  /// OR List of files path
  Future<FilePickerResult?> documentsPicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  /// Genrate fileName which will locally saved
  String _localNameGenerator(String mimeType) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    switch (mimeType) {
      case MediaType.image:
        return 'IMG-$uploadingDate-$uploadingTime';

      case MediaType.video:
        return 'VID-$uploadingDate-$uploadingTime';
      case MediaType.document:
        return 'DOC-$uploadingDate-$uploadingTime';
      default:
        return 'DOC-$uploadingDate-$uploadingTime';
    }
  }

  /// Get the selected media List length picked from gallery
  Future<int> pickedMediaLength(List<AssetEntity> assets) async {
    final files = await Future.wait(assets.map((e) => e.file));

    final sizes = files.map((e) => e!.lengthSync()).toList();

    /// Size in bytes
    final sum = sizes.reduce((a, b) => a + b);

    /// Size in kb
    var sizeinKB = sum / 1024;

    var sizeInMB = sizeinKB / 1024;

    log.wtf('PickedImage Size in MB:$sizeInMB');

    return sizeInMB.toInt();
  }

  /// Get the selected docs List length picked from gallery
  Future<int> pickedDocumentsLength(List<File> files) async {
    final sizes = files.map((e) => e.lengthSync()).toList();

    /// Size in bytes
    final sum = sizes.reduce((a, b) => a + b);

    /// Size in kb
    var sizeinKB = sum / 1024;

    var sizeInMB = sizeinKB / 1024;

    log.wtf('PickedImage Size in MB:$sizeInMB');

    return sizeInMB.toInt();
  }

  /// compress the picked image
  Future<File> _compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = math.Random().nextInt(10000);

    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    // choose the size here, it will maintain aspect ratio
    img.Image smallerImage =
        img.copyResize(image!, height: image.height, width: image.width);

    var compressedImage = File('$path/img_$rand.jpeg')
      ..writeAsBytesSync(img.encodeJpg(smallerImage, quality: 40));

    var sizeinKB = compressedImage.lengthSync() / 1024;

    var sizeInMB = sizeinKB / 1024;

    log.wtf('CompressedImage Size in MB:$sizeInMB');
    return compressedImage;
  }

  /// Genrate thumbnail for video and save it locally
  Future<File> _videoThumnailGenerator(File file) async {
    final thumbnailFile =
        await VideoCompress.getFileThumbnail(file.path, quality: 40);

    final mediaName = _localNameGenerator(MediaType.image);

    pathFinder.saveInLocalPath(thumbnailFile,
        mediaName: mediaName,
        folderPath: 'Media/Thumbnails',
        extension: 'jpeg');
    return thumbnailFile;
  }

  /// Add the message in firestore and return the messageUid of the added message
  Future<String> _getMessageUid(String mediaType,
      {String? hash,
      int? fileSize,
      String? localPath,
      String? thumbnailPath,
      required String downloadURL,
      String? documentTitle}) async {
    switch (mediaType) {
      case MediaType.image:
        {
          // * Add message when type is image
          // * we need blurhash for display raw data of video thumbnail
          // * if image is not present offline of in firestore storage
          // * OR is hive path is empty
          final messageUid = await chatService
              .addNewMessage(
                  blurHash: hash,
                  type: mediaType,
                  fileSize: fileSize,
                  localPath: localPath,
                  mediaUrl: downloadURL,
                  receiverUid: fireUser.id)
              .whenComplete(() => log.w('Image Message added'));
          return messageUid;
        }

      case MediaType.video:
        {
          // * Add message when type is video
          // * we need blurhash for display raw data of image
          // * if image is not present offline of in firestore storage
          // * OR is hive path is empty
          final messageUid = await chatService
              .addNewMessage(
                  blurHash: hash,
                  type: mediaType,
                  fileSize: fileSize,
                  localPath: localPath,
                  mediaUrl: downloadURL,
                  receiverUid: fireUser.id,
                  senderThumbnail: thumbnailPath)
              .whenComplete(() => log.w('Video Message added'));
          return messageUid;
        }
      case MediaType.document:
        {
          // * Add message when type is document
          final messageUid = await chatService
              .addNewMessage(
                  type: mediaType,
                  mediaUrl: downloadURL,
                  receiverUid: fireUser.id,
                  documentTitle: documentTitle)
              .whenComplete(() => log.w('Document Message added'));
          return messageUid;
        }
      default:
        {
          // * This is the default case for adding message in firestore database
          final messageUid = await chatService
              .addNewMessage(
                  type: mediaType,
                  mediaUrl: downloadURL,
                  receiverUid: fireUser.id)
              .whenComplete(() => log.w('Document Message added'));
          return messageUid;
        }
    }
  }

  /// This will decide the folder of the downloaded or saved media locally
  String folderPathDecider(String mediaType) {
    switch (mediaType) {
      case MediaType.image:
        {
          return 'Media/Convo Images/Send';
        }

      case MediaType.video:
        {
          return 'Media/Convo Videos/Send';
        }

      default:
        {
          return 'Media/Convo Documents/Send';
        }
    }
  }

  /// upload media into firebase storage and get progress
  Future<String> _uploadFile({
    String? hash,
    File? thumbnail,
    String? documentTitle,
    required String filePath,
    required String mediaType,
    required String extension,
    required String firestorePath,
  }) async {
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(firestorePath)
        .putFile(File(filePath));
    try {
      task.snapshotEvents.listen(
        (snapshot) {
          var progress = snapshot.bytesTransferred / snapshot.totalBytes;
          log.v((snapshot.bytesTransferred / snapshot.totalBytes) * 100);

          /// uploading progress of file
          updateProgress(progress);
        },
      );
    } on firebase_core.FirebaseException catch (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      log.wtf(task.snapshot);

      if (e.code == 'permission-denied') {
        log.e('User does not have permission to upload to this reference.');
      }
    }
    await task;

    /// This is the download Url of media
    ///  which was uploaded to the firestore storage
    String downloadURL = await _storage.ref(firestorePath).getDownloadURL();

    /// Generate the filename or medianame for locally downloaded file
    /// which will saved in convo application folder
    String mediaName = _localNameGenerator(mediaType);

    String folder = folderPathDecider(mediaType);

    /// This will save the copy of selected file in the convo app
    /// local directory or folder
    final savedFile = await pathFinder.saveInLocalPath(File(filePath),
        mediaName: mediaName, folderPath: folder, extension: extension);

    /// Add the message in firestore and
    /// return the messageUid after adding message
    await _getMessageUid(
      mediaType,
      hash: hash,
      downloadURL: downloadURL,
      localPath: savedFile.path,
      documentTitle: documentTitle,
      thumbnailPath: thumbnail?.path,
      fileSize: File(filePath).lengthSync(),
    );

    // if (thumbnail != null) {
    //   final map = {
    //     MediaHiveBoxField.taskID: null,
    //     MediaHiveBoxField.thumbnailPath: thumbnail.path,
    //     MediaHiveBoxField.localPath: savedFile.path,
    //   };

    //   /// This will save the path of saved file in hive local database
    //   Hive.box(HiveApi.mediaHiveBox).put(messageUid, map).whenComplete(
    //       () => log.wtf('Image Path is saved in hive ${savedFile.path}'));
    // } else {
    //   /// This will save the path of saved file in hive local database
    //   Hive.box(HiveApi.mediaHiveBox)
    //       .put(messageUid, savedFile.path)
    //       .whenComplete(
    //           () => log.wtf('Image Path is saved in hive ${savedFile.path}'));
    // }

    return downloadURL;
  }

  /// Genrate File Name For Firebase Storage Bucket
  /// and upload to firebase storage and add to firestore
  Future<String> uploadAndAddToDatabase(AssetEntity asset) async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    final mimeType = asset.mimeType!.split("/").first;
    final fileExtension = asset.mimeType!.split("/").last;

    /// Generate firebase store file name
    String storagePath = mimeType == MediaType.image
        ? 'IMG-$uploadingDate-$uploadingTime.$fileExtension'
        : 'VID-$uploadingDate-$uploadingTime.$fileExtension';

    final date = DateFormat('yMMMMd').format(now);
    final firebasePath = 'ChatMedia/$date/$storagePath';

    log.v(asset.mimeType);
    log.v('MimeType:$mimeType | FileExtension:$fileExtension');
    log.v('FirebaseStoragePath:$storagePath');

    File? file = await asset.file;

    switch (mimeType) {
      case MediaType.image:
        {
          final compressedImage = await _compressImage(file!);
          final hash = await _blurHashString(compressedImage);
          return _uploadFile(
              hash: hash,
              filePath: compressedImage.path,
              mediaType: mimeType,
              extension: fileExtension,
              firestorePath: firebasePath);
        }

      case MediaType.video:
        {
          File thumbnail = await _videoThumnailGenerator(File(file!.path));
          final hash = await _blurHashString(thumbnail);
          return _uploadFile(
              hash: hash,
              mediaType: mimeType,
              filePath: file.path,
              thumbnail: thumbnail,
              extension: fileExtension,
              firestorePath: firebasePath);
        }
      case MediaType.document:
        {
          return _uploadFile(
            filePath: file!.path,
            extension: fileExtension,
            documentTitle: asset.title,
            firestorePath: firebasePath,
            mediaType: MediaType.document,
          );
        }
      default:
        {
          return _uploadFile(
            filePath: file!.path,
            extension: fileExtension,
            documentTitle: asset.title,
            firestorePath: firebasePath,
            mediaType: MediaType.document,
          );
        }
    }
  }

  /// Genrate File Name For Firebase Storage Bucket
  /// and upload to firebase storage and add to firestore
  Future<String> uploadDocs(PlatformFile platformFile) async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    log.wtf('Extension:${platformFile.extension}');

    String? mime = lookupMimeType(platformFile.path!);

    log.wtf('Mime:$mime');

    final mimeType = mime!.split("/").first;
    final fileExtension = mime.split("/").last;

    /// Generate firebase store file name
    String storagePath = mimeType == MediaType.image
        ? 'IMG-$uploadingDate-$uploadingTime.$fileExtension'
        : 'VID-$uploadingDate-$uploadingTime.$fileExtension';

    final date = DateFormat('yMMMMd').format(now);
    final firebasePath = 'ChatMedia/$date/$storagePath';

    log.v(mimeType);
    log.v('MimeType:$mimeType | FileExtension:$fileExtension');
    log.v('FirebaseStoragePath:$storagePath');

    File file = File(platformFile.path!);

    switch (mimeType) {
      case MediaType.image:
        {
          final compressedImage = await _compressImage(file);
          final hash = await _blurHashString(compressedImage);
          return _uploadFile(
              hash: hash,
              mediaType: mimeType,
              extension: fileExtension,
              firestorePath: firebasePath,
              filePath: compressedImage.path);
        }

      case MediaType.video:
        {
          File thumbnail = await _videoThumnailGenerator(File(file.path));
          final hash = await _blurHashString(thumbnail);
          return _uploadFile(
              hash: hash,
              mediaType: mimeType,
              filePath: file.path,
              thumbnail: thumbnail,
              extension: fileExtension,
              firestorePath: firebasePath);
        }
      case MediaType.document:
        {
          return _uploadFile(
            filePath: file.path,
            extension: fileExtension,
            firestorePath: firebasePath,
            mediaType: MediaType.document,
            documentTitle: platformFile.name,
          );
        }
      default:
        {
          return _uploadFile(
            filePath: file.path,
            extension: fileExtension,
            firestorePath: firebasePath,
            mediaType: MediaType.document,
            documentTitle: platformFile.name,
          );
        }
    }
  }

  /// get current user chat collection OR messages
  Stream<QuerySnapshot<Map<String, dynamic>>> get getUserchat =>
      _conversationCollection
          .doc(conversationId)
          .collection(chatsFirestoreKey)
          .orderBy(DocumentField.timestamp, descending: true)
          .snapshots();

  String _messageText = '';
  String get messageText => _messageText;

  void updateMessageText(String value) {
    _messageText = value.trim();
    notifyListeners();
  }

  Future<void> updateUserDataWithKey(String key, dynamic value) =>
      databaseService.updateUserDataWithKey(key, value);

  Stream<DatabaseEvent> get realtimeDBDocument => FirebaseDatabase.instance
      .ref()
      .child(dulesRealtimeDBKey)
      .child(fireUser.id)
      .onValue;

  void updateAnimation(
      {required BuildContext context,
      required AnimationController controller,
      required String animationType}) {
    databaseService.updateUserDataWithKey(
        DatabaseMessageField.aniType, animationType);
    controller.forward().whenComplete(() {
      controller.reset();
      databaseService.updateUserDataWithKey(
          DatabaseMessageField.aniType, animationType);
    });

    Navigator.pop(context);
  }

  /// Add text message to firestore
  addMessage() {
    bool reply = locator.get<GetReplyMessageValue>().isReply;
    messageTech.clear();
    updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    reply == false
        ? chatService.addNewMessage(
            type: MediaType.text,
            receiverUid: fireUser.id,
            messageText: _messageText)
        : chatService.addNewMessage(
            isReply: true,
            type: MediaType.text,
            receiverUid: fireUser.id,
            messageText: _messageText,
            swipeMsgUid: locator.get<GetReplyMessageValue>().messageUid,
            swipeMsgText: locator.get<GetReplyMessageValue>().messageText,
            swipeMediaURL: locator.get<GetReplyMessageValue>().mediaURL,
            swipeMsgType: locator.get<GetReplyMessageValue>().messageType,
            swipeDocTitle: locator.get<GetReplyMessageValue>().documentTitle,
          );
    updateMessageText('');
  }

  final TextEditingController messageTech = TextEditingController();

  @override
  void dispose() {
    databaseService.updateUserDataWithKey(DatabaseMessageField.roomUid, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    databaseService.updateUserDataWithKey(DatabaseMessageField.url, null);
    databaseService.updateUserDataWithKey(DatabaseMessageField.urlType, '');
    super.dispose();
  }
}
