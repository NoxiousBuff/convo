import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmo_media_picker/media_picker.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/api/path_finder.dart';
import 'package:hint/api/replymessage_value.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:video_compress_ds/video_compress_ds.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({required this.conversationId, required this.fireUser});

  FireUser fireUser;

  String conversationId;

  final log = getLogger('ChatViewModel');
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  static final CollectionReference _conversationCollection =
      FirebaseFirestore.instance.collection(conversationFirestorekey);

  double? _uploadingFileProgress;
  double? get fileProgress => _uploadingFileProgress;

  String _uploadingFileTitle = '';
  String get fileTitle => _uploadingFileTitle;

  bool _isReply = false;
  bool get isReply => _isReply;

  // ignore: prefer_final_fields
  // List<Map> _selectedMediaList = [];
  // List<Map> get selectedMediaList => _selectedMediaList;

  void changeTitle(String title) {
    _uploadingFileTitle = title;
    notifyListeners();
  }

  /// CHange the value of isReply bool
  void isReplyValue(bool value) {
    _isReply = value;
    notifyListeners();
  }

  /// add into media list
  // void addToMediaList(
  //     {required String url,
  //     required String mediaType,
  //     required String mediaName}) {
  //   Map<String, dynamic> map = <String, dynamic>{
  //     'URL': url,
  //     'MediaType': mediaType,
  //     'MediaName': mediaName,
  //   };
  //   log.wtf('addedMedia: $map');
  //   _selectedMediaList.add(map);
  // }

  /// clear the media list
  //void clearTheList() => _selectedMediaList.clear();

  /// Reset the current progress of file after uploading
  void updateProgress(double? value) {
    _uploadingFileProgress = value;
    notifyListeners();
  }

  /// Genrate fileName which will locally saved
  String localNameGenerator(String mimeType) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    String mediaName = mimeType == MediaType.image
        ? 'IMG-$uploadingDate-$uploadingTime'
        : 'VID-$uploadingDate-$uploadingTime';

    return mediaName;
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

  /// compress the picked image
  Future<File> compressImage(File imageFile) async {
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

  /// Compress the video
  Future<File?> compressVideo(File file) async {
    final originalLength = file.lengthSync();
    double sizeInKB = originalLength / 1024;
    double sizeInMB = sizeInKB / 1024;
    log.wtf('PickedVideo Size in MB:$sizeInMB');
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // It's false by default
    );
    log.wtf('CompressedVideo Size in MB:${mediaInfo!.filesize}');
    return mediaInfo.file;
  }

  /// Genrate thumbnail for video and save it locally
  Future<File> videoThumnailGenerator(File file) async {
    final thumbnailFile =
        await VideoCompress.getFileThumbnail(file.path, quality: 40);

    final mediaName = localNameGenerator(MediaType.image);

    pathFinder.saveInLocalPath(thumbnailFile,
        mediaName: mediaName,
        folderPath: 'Media/Thumbnails',
        extension: 'jpeg');
    return thumbnailFile;
  }

  /// upload media into firebase storage and get progress
  Future<String> uploadFile({
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
    String downloadURL = await _storage.ref(firestorePath).getDownloadURL();

    final messageUid = await chatService
        .addNewMessage(
            receiverUid: fireUser.id, type: mediaType, mediaUrl: downloadURL)
        .whenComplete(() => log.w('Message added to firestore successfully'));

    final mediaName = localNameGenerator(mediaType);

    log.wtf('MediaType:$mediaType');

    switch (mediaType) {
      case MediaType.image:
        {
          String folderPath = mediaType == MediaType.image
              ? 'Media/Convo Images/Send'
              : 'Media/Convo Videos/Send';

          final savedFile = await pathFinder.saveInLocalPath(File(filePath),
              mediaName: mediaName,
              folderPath: folderPath,
              extension: extension);

          Hive.box(HiveApi.mediaHiveBox)
              .put(messageUid, savedFile.path)
              .whenComplete(() =>
                  log.wtf('Image Path is saved in hive ${savedFile.path}'));
        }

        break;
      case MediaType.video:
        {
          final thumbnail = await videoThumnailGenerator(File(filePath));
          String folderPath = mediaType == MediaType.image
              ? 'Media/Convo Images/Send'
              : 'Media/Convo Videos/Send';

          final savedFile = await pathFinder.saveInLocalPath(File(filePath),
              mediaName: mediaName,
              folderPath: folderPath,
              extension: extension);
          Map<String, dynamic> map = {
            VideoThumbnailField.localVideoPath: savedFile.path,
            VideoThumbnailField.videoThumbnailPath: thumbnail.path
          };

          Hive.box(HiveApi.mediaHiveBox).put(messageUid, map).whenComplete(
              () => log.wtf('Video Map Saved | Video Path ${savedFile.path}'));
        }
        break;
      default:
    }

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
          final compressedImage = await compressImage(file!);
          return uploadFile(
              filePath: compressedImage.path,
              mediaType: mimeType,
              extension: fileExtension,
              firestorePath: firebasePath);
        }

      case MediaType.video:
        {
          return uploadFile(
              mediaType: mimeType,
              filePath: file!.path,
              extension: fileExtension,
              firestorePath: firebasePath);
        }

      default:
        {
          return uploadFile(
              filePath: file!.path,
              mediaType: mimeType,
              extension: fileExtension,
              firestorePath: firebasePath);
        }
    }
  }

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

  /// Add text message to firestore
  addMessage() {
    bool reply = locator.get<GetReplyMessageValue>().isReply;
    messageTech.clear();
    updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    reply == false
        ? chatService.addNewMessage(
            receiverUid: fireUser.id,
            type: MediaType.text,
            messageText: _messageText)
        : chatService.addNewMessage(
            isReply: true,
            type: MediaType.text,
            receiverUid: fireUser.id,
            messageText: _messageText,
            swipeMsgUid: locator.get<GetReplyMessageValue>().messageUid,
            swipeMsgText: locator.get<GetReplyMessageValue>().messageText,
            swipeMediaURL: locator.get<GetReplyMessageValue>().messageURL,
            swipeMsgType: locator.get<GetReplyMessageValue>().messageType,
          );
    updateMessageText('');
  }

  /// Add Media Message To Firestore
  // Future addMediaMessage(String mediaType, String mediaUrl) =>
  //     chatService.addNewMessage(
  //         receiverUid: fireUser.id, type: mediaType, mediaUrl: mediaUrl);

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
