import 'dart:io';
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
import 'package:hint/ui/shared/custom_snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class DuleViewModel extends StreamViewModel<Event> {
  DuleViewModel(this.fireUser);

  final FireUser fireUser;
  final log = getLogger('DuleViewModel');

  String _conversationId = '';
  String get conversationId => _conversationId;

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  TaskState _state = TaskState.success;
  TaskState get state => _state;

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

  Future<void> updateUserDataWithKey(String key, dynamic value) {
    return databaseService.updateUserDataWithKey(key, value);
  }

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

  /// Clicking Image from camera
  Future<File?> pickImage(BuildContext context) async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (selectedImage != null) {
      final file = File(selectedImage.path);
      final size = file.lengthSync();
      final sizeInMB = size / (1024 * 1024);
      final fileSize = sizeInMB.toInt();
      log.wtf('Image Size:$fileSize');
      if (fileSize > 8) {
        customSnackbars.errorSnackbar(context,
            title: 'Maximum size of upload is 8 MB.');
      } else {
        return file;
      }
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

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

  // Pick File From Gallery
  Future<void> pickFromGallery(BuildContext context) async {
    const pickFile = FileType.media;
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(type: pickFile, withData: true);

    if (result != null) {
      for (var path in result.paths) {
        if (path != null) {
          final size = File(path).lengthSync();
          final sizeInMB = size / (1024 * 1024);
          final fileSize = sizeInMB.toInt();
          log.wtf('File Size: $fileSize MB');
          if (fileSize > 8) {
            customSnackbars.errorSnackbar(context,
                title: 'Maximum size of upload is 8 MB.');
          } else {
            await uploadFile(
                filePath: path,
                context: context,
                fileName: result.files.first.name);
          }
        }
      }
    } else {
      log.wtf('Result is null now!!');
    }
  }

  Future<String> uploadFile({
    required String filePath,
    required String fileName,
    required BuildContext context,
  }) async {
    var now = DateTime.now();
    var hourPart = '${now.year}${now.month}${now.day}${now.hour}';
    var secondPart = '${now.minute}${now.second}${now.millisecond}';
    final firebasename = hourPart + secondPart;
    final fileType = lookupMimeType(filePath)!.split("/").first;
    String folder = fileType == MediaType.image
        ? 'live Chat/$fileName-$firebasename'
        : 'live Chat/$fileName-$firebasename';

    UploadTask task = storage.ref(folder).putFile(File(filePath));

    task.timeout(const Duration(seconds: 10), onTimeout: () {
      setBusy(false);
      return task;
    });
    setBusy(true);
    task.snapshotEvents.listen(
      (TaskSnapshot snapshot) {
        log.i('Task state: ${snapshot.state}');
        final progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();

        _state = snapshot.state;
        _uploadingProgress = progress;
        notifyListeners();
        log.wtf(_uploadingProgress);
      },
      onError: (e) {
        setBusy(false);
        task.cancel();
        customSnackbars.errorSnackbar(context, title: 'Failed to upload file');
      },
    );
    await task;
    String downloadURL = await storage.ref(folder).getDownloadURL();
    setBusy(false);
    return downloadURL;
  }

  Stream<Event> realtimeDBDocument() {
    return FirebaseDatabase.instance
        .reference()
        .child(dulesRealtimeDBKey)
        .child(fireUser.id)
        .onValue;
  }

  @override
  Stream<Event> get stream => realtimeDBDocument();
}
