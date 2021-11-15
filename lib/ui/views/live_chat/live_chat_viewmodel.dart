import 'dart:io';
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:hint/api/realtime_database_api.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:mime/mime.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'live_chat.dart';
import 'live_chat_animation.dart';

class LiveChatViewModel extends BaseViewModel {
  final log = getLogger('LiveChatViewModel');

  double _uploadingProgress = 0.0;
  double get uploadingProgress => _uploadingProgress;

  TaskState _state = TaskState.success;
  TaskState get state => _state;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  CurveTween curveTween =
      CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.ease));
  CurveTween curveTween2 =
      CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.ease));

  /// Radius of Spotlight
  Animation<double> spotLightRadius(AnimationController controller) {
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: 5.0, end: 0.5).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: 0.5, end: 5.0).chain(curveTween2), weight: 50)
      ],
    ).animate(controller);
  }

  ///  particles container height
  Animation<double> spotLightParticlesHeight(
      AnimationController controller, BuildContext context) {
    final size = MediaQuery.of(context).size;
    double begin = size.height * 0.0;
    double end = size.height * 0.4;
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: begin, end: end).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: end, end: begin).chain(curveTween2),
            weight: 50),
      ],
    ).animate(controller);
  }

  ///  Particles Container Width
  Animation<double> spotLightParticlesWidth(AnimationController controller) {
    return TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 400.0).chain(curveTween), weight: 50),
        TweenSequenceItem(
            tween: Tween(begin: 400.0, end: 0.0).chain(curveTween2),
            weight: 50),
      ],
    ).animate(controller);
  }

  // getting animation Value
  Future<void> getAnimationValue({
    required BuildContext context,
    String? fireUserId,
    required ConfettiController confettiController,
    required AnimationController spotlightController,
  }) async {
    final val = await Navigator.push(
      context,
      cupertinoTransition(
        enterTo: const LiveChatAnimations(),
        exitFrom: const LiveChat(),
      ),
    );
    log.wtf('Animation Value:$val');
    if (val == AnimationType.confetti) {
      confettiController.play();
      await realtimeDBApi.updateUserDocument(
        fireUserId!,
        {LiveChatField.animationType: val},
      );
    } else if (val == AnimationType.spotlight) {
      spotlightController.forward();
      await realtimeDBApi.updateUserDocument(
        fireUserId!,
        {LiveChatField.animationType: val},
      );
    } else {
      log.wtf('Animation is null');
    }
  }

  /// uploading a single file into the firebase storage and get progress
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

    firebase_storage.UploadTask task =
        storage.ref(folder).putFile(File(filePath));

    task.timeout(const Duration(seconds: 10), onTimeout: () {
      setBusy(false);
      return task;
    });

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        setBusy(true);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: inactiveGray,
            content: Text(
              'Failed to upload file',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: systemBackground),
            ),
          ),
        );
      },
    );
    await task;
    String downloadURL = await storage.ref(folder).getDownloadURL();
    setBusy(false);
    return downloadURL;
  }

  //Alert Dialog For larger File
  Future<void> sizeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Too Large File Size',
              style: Theme.of(context).textTheme.bodyText1),
          content: Text(
            'Your file size is too large maximum file size is 8 MB',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: activeBlue),
              ),
            ),
          ],
        );
      },
    );
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
        sizeDialog(context);
      } else {
        return file;
      }
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

  /// Record a Video from camera
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
        sizeDialog(context);
      } else {
        return file;
      }
    } else {
      log.wtf('pickVideo | Video was not recorded');
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
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Too Large File Size',
                      style: Theme.of(context).textTheme.bodyText1),
                  content: Text(
                    'Your file size is too large maximum file size is 8 MB',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: activeBlue),
                      ),
                    ),
                  ],
                );
              },
            );
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

  Future<void> cameraOptions(
      {required BuildContext context,
      required void Function() takePicture,
      required void Function() recordVideo}) async {
    Widget option(
        {required void Function() onTap, required String optionText}) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(optionText, style: Theme.of(context).textTheme.bodyText2),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: systemBackground,
              constraints: BoxConstraints(
                maxHeight: screenHeightPercentage(context, percentage: 0.26),
                maxWidth: screenHeightPercentage(context, percentage: 0.3),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    child: Text('I Want To',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  const Divider(height: 0),
                  Column(
                    children: [
                      option(
                        optionText: 'Take a picture',
                        onTap: takePicture,
                      ),
                      const Divider(height: 0),
                      option(
                        optionText: 'Record a video',
                        onTap: recordVideo,
                      ),
                      const Divider(height: 0),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: activeBlue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> statusStream(
      String fireUserID) {
    return FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(fireUserID)
        .snapshots();
  }
}
