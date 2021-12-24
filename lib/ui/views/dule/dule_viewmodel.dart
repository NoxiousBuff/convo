import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:hint/models/dule_model.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class DuleViewModel extends StreamViewModel<DatabaseEvent> {
  DuleViewModel(this.fireUser);

  final FireUser fireUser;
  final log = getLogger('DuleViewModel');

  /// Type of sending media to other user
  String? _sendingMediaType = '';
  String? get sendingMediaType => _sendingMediaType;

  /// Path of sending media to user
  String? _sendingMediaPath;
  String? get sendingMediaPath => _sendingMediaPath;

  /// conversationIs of this live chat
  String _conversationId = '';
  String get conversationId => _conversationId;

  /// uploading progress od media which is uploading in firebase storage
  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  /// Instance od Firebase Storage
  FirebaseStorage storage = FirebaseStorage.instance;

  void createGetConversationId() {
    _conversationId =
        chatService.getConversationId(fireUser.id, AuthService.liveUser!.uid);
    notifyListeners();
  }

  final TextEditingController duleTech = TextEditingController();

  final TextEditingController otherTech = TextEditingController();

  String _wordLengthLeft = '160';
  String get wordLengthLeft => _wordLengthLeft;

  int _duleFlexFactor = 1;
  int get duleFlexFactor => _duleFlexFactor;

  int _otherFlexFactor = 1;
  int get otherFlexFactor => _otherFlexFactor;

  bool _isDuleEmpty = true;
  bool get isDuleEmpty => _isDuleEmpty;

  final FocusNode duleFocusNode = FocusNode();

  void updateDuleFocus() {
    duleFocusNode.hasFocus
        ? duleFocusNode.unfocus()
        : duleFocusNode.requestFocus();
    notifyListeners();
  }

  void onTextChanged(String value) {}

  void updatTextFieldWidth() {
    final duleLength = duleTech.text.length;
    final otherLength = otherTech.text.length;
    if (otherLength < 30) {
      if (duleLength < 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 2;
      } else {
        _duleFlexFactor = 6;
        _otherFlexFactor = 2;
      }
    } else if (otherLength > 30) {
      if (duleLength < 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 6;
      } else if (duleLength > 30) {
        _duleFlexFactor = 2;
        _otherFlexFactor = 2;
      }
    }
    _isDuleEmpty = duleTech.text.isEmpty;
    notifyListeners();
  }

  /// Update live user data in realtime database.
  Future<void> updateUserDataWithKey(String key, dynamic value) {
    return databaseService.updateUserDataWithKey(key, value);
  }

  Future<void> updateFireUserDataWithKey(
      String fireUserId, String key, dynamic value) {
    return databaseService.updateFireUserDataWithKey(fireUserId, key, value);
  }

  /// clear the type message
  void clearMessage() {
    if (!isDuleEmpty) {
      duleTech.clear();
      _isDuleEmpty = true;
      updatTextFieldWidth();
      updateWordLengthLeft(duleTech.text);
      updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
    }
  }

  void updateOtherField(String value) {
    otherTech.text = value;
  }

  void updateWordLengthLeft(String value) {
    final lengthLeft = 160 - value.length;
    _wordLengthLeft = lengthLeft.toString();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    duleFocusNode.dispose();
    duleTech.dispose();
    otherTech.dispose();
  }

  /// change sender media path
  void _changeSenderMediaPath(String? path) {
    _sendingMediaPath = path;
    notifyListeners();
  }

  /// change sender media type
  void _changeSenderMediaType(String? type) {
    _sendingMediaType = type;
    notifyListeners();
    log.v('MediaType:$_sendingMediaType');
  }

  /// Get uploading progress of media
  void _getMediaUploadingProgress(double value) {
    _uploadingProgress = value;
    notifyListeners();
  }

  /// Clicking Image from camera
  Future<File?> pickImage(BuildContext context) async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (selectedImage != null) {
      final file = File(selectedImage.path);
      final size = file.lengthSync();
      final sizeInMB = size / (1024 * 1024);
      final fileSize = sizeInMB;
      log.wtf('Image Size:$fileSize');
      if (fileSize > 8.0) {
        customSnackbars.errorSnackbar(context,
            title: 'Maximum size of upload is 8 MB.');
      } else {
        return file;
      }
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

  /// Make a video through camera
  Future<File?> pickVideo(BuildContext context) async {
    final selectedVideo =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    if (selectedVideo != null) {
      final file = File(selectedVideo.path);
      final size = file.lengthSync();
      final sizeInMB = size / (1024 * 1024);
      final fileSize = sizeInMB.toInt();
      log.wtf('Video Size:$fileSize');
      if (fileSize > 8) {
        customSnackbars.errorSnackbar(context,
            title: 'Maximum size of upload is 8 MB.');
      } else {
        return file;
      }
    } else {
      log.wtf('pickVideo | Video was not recorded');
    }
  }

  Future<void> updateAnimation(String? value) async {
    switch (value) {
      case AnimationType.confetti:
        {
          await updateUserDataWithKey(DatabaseMessageField.aniType, value);
        }

        break;
      case AnimationType.balloons:
        {
          await updateUserDataWithKey(DatabaseMessageField.aniType, value);
        }
        break;
      default:
        {
          await updateUserDataWithKey(DatabaseMessageField.aniType, null);
        }
    }
  }

  /// Picke Media From Gallery
  Future pickGallery(BuildContext context) async {
    String title = 'Maximum file size is 8 MB';
    const type = FileType.media;
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(
        type: type, withData: true, dialogTitle: 'Pick Media');
    if (result != null) {
      final path = result.paths.first;
      final fileName = result.names.first;
      final fileSizeInBytes = File(path!).lengthSync();
      // Convert the bytes to Kilobytes (1 KB = 1024 Bytes)
      double fileSizeInKB = fileSizeInBytes / 1024;
      // Convert the KB to MegaBytes (1 MB = 1024 KBytes)
      double fileSizeInMB = fileSizeInKB / 1024;
      final fileSize = fileSizeInMB.toInt();
      log.wtf('File Size: $fileSize MB');
      if (fileSize > 8) {
        setBusy(false);
        customSnackbars.infoSnackbar(context, title: title);
      } else {
        _changeSenderMediaPath(path);
        log.v('MediaPath:$_sendingMediaPath');
        await uploadFile(filePath: path, fileName: fileName!, context: context);
      }
      return File(result.paths.first!);
    } else {
      log.wtf('Nothing was picked from gallery');
      return null;
    }
  }

  /// Upload File In Firebase Storage
  Future<String> uploadFile({
    required String filePath,
    required String fileName,
    required BuildContext context,
  }) async {
    var now = DateTime.now();
    var day = now.day;
    var year = now.year;
    var month = now.month;

    final fileType = lookupMimeType(filePath)!.split("/").first;
    var folderDate = '$day-$month-$year';
    String folder = 'LiveChatMedia/$folderDate/$fileName';

    UploadTask task = storage.ref(folder).putFile(File(filePath));
    _changeSenderMediaType(fileType);
    task.timeout(const Duration(seconds: 10), onTimeout: () {
      setBusy(false);
      _changeSenderMediaPath(null);
      _changeSenderMediaType(null);
      return task;
    });
    setBusy(true);
    task.snapshotEvents.listen(
      (TaskSnapshot snapshot) {
        log.i('Task state: ${snapshot.state}');
        final progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();

        _getMediaUploadingProgress(progress);

        log.wtf(_uploadingProgress);
      },
      onError: (e) {
        setBusy(false);
        _changeSenderMediaPath(null);
        _changeSenderMediaType(null);

        task.cancel();
        customSnackbars.errorSnackbar(context, title: 'Failed to upload file');
      },
    );
    await task;
    String downloadURL = await storage.ref(folder).getDownloadURL();
    await updateUserDataWithKey(DatabaseMessageField.url, downloadURL);
    await updateUserDataWithKey(DatabaseMessageField.urlType, fileType);

    setBusy(false);
    _changeSenderMediaPath(null);
    _changeSenderMediaType(null);
    log.v('MediaPath:$_sendingMediaPath');

    return downloadURL;
  }

  Stream<DatabaseEvent> realtimeDBDocument() {
    return FirebaseDatabase.instance
        .ref()
        .child(dulesRealtimeDBKey)
        .child(fireUser.id)
        .onValue;
  }

  void listenReceiverAnimation(
      DuleModel model,
      AnimationController balloonsController,
      ConfettiController confettiController) {
    if (model.aniType == AnimationType.confetti) {
      log.wtf('Begin Confetti');
      confettiController.play();
    } else if (model.aniType == AnimationType.balloons) {
      log.wtf('Begin Balloons');
      balloonsController.forward();
    } else {
      log.wtf('No animation is running now !!');
    }
  }

  @override
  Stream<DatabaseEvent> get stream => realtimeDBDocument();
}