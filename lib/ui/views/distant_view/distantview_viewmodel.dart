import 'dart:io';
import 'package:hint/api/dio.dart';
import 'package:hint/app/app.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/ui/views/login_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DistantViewViewModel extends BaseViewModel {
  final bool _isUploading = false;
  final _auth = FirebaseAuth.instance;
  bool get isUploading => _isUploading;
  final log = getLogger('DistantViewModel');

  /// Clicking Image from camera
  Future<File?> pickImage(ImageSource imageSource) async {
    final selectedImage = await ImagePicker().pickImage(source: imageSource);

    if (selectedImage != null) {
      return File(selectedImage.path);
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void themeChanger(bool value) {
    isDarkTheme = value;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    setBusy(true);
    await firestoreApi.updateUser(
      updateProperty: 'Offline',
      property: UserField.status,
      uid: FirestoreApi.liveUserUid,
    );

    await _auth.signOut().catchError((e) => log.e('Firestore Signout:$e'));
    setBusy(false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginView()));
  }

  /// uploading a single file into the firebase storage and get progress
  Future<String> uploadFile({
    required String filePath,
  }) async {
    var now = DateTime.now();
    var firstPart = '${now.year}${now.month}${now.day}';
    var secondPart = '${now.hour}${now.minute}${now.second}';

    final profileImage = 'IMG-$firstPart-Hint$secondPart';

    firebase_storage.UploadTask task = storage
        .ref('ChatBackgroundImages/$profileImage')
        .putFile(File(filePath));

    task.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        log.i('Task state: ${snapshot.state}');
        var progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
        setBusyForObject(_isUploading, true);

        log.i('UploadingProgress: $progress%');
      },
      onError: (e) {
        log.e(task.snapshot);
        if (e.code == 'permission-denied') {
          log.i('User does not have permission to upload to this reference.');
        }
      },
    );
    await task;
    String downloadURL = await storage
        .ref('ChatBackgroundImages/$profileImage')
        .getDownloadURL();

    log.wtf('Background Image uploaded !!');
    setBusyForObject(_isUploading, false);
    return downloadURL;
  }

  DioApi dioApi = DioApi();
  Directory? globalDirectory;
  HiveHelper hiveHelper = HiveHelper();

  Future<void> uploadAndSave(String filePath) async {
    final downloadURL = await uploadFile(filePath: filePath);
    await saveMediaPath(mediaURL: downloadURL);
  }

  Future<void> saveMediaPath({
    required String mediaURL,
  }) async {
    final now = DateTime.now();
    final firstPart = '${now.year}${now.month}${now.day}';
    final secondPart = '${now.hour}${now.minute}${now.second}';
    final mediaName = '$firstPart-H$secondPart';
    log.wtf('mediaName:$mediaName');
    await savePath(
      mediaUrl: mediaURL,
      mediaName: 'IMG-$mediaName.jpeg',
      folderPath: 'Media/Chat Backgrounds',
    );
  }

  Future<void> savePath({
    required String mediaUrl,
    required String mediaName,
    required String folderPath,
  }) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory());
          String newPath = "";
          //log.wtf(directory);
          List<String> paths = directory!.path.split("/");
          //log.wtf(directory.path);
          //log.wtf(paths);
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          String backPath = '/Hint' '/$folderPath';
          //todo: remove
          //log.wtf('Back Path of the Folder : $backPath');
          newPath = newPath + backPath;
          directory = Directory(newPath);
          //log.wtf('Path of the newly created directory : ${directory.path}');
        } else {}
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {}
      }

      String savePath = directory!.path + "/$mediaName";
      log.i('ImagePath: $savePath');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        await dioApi.downloadMediaFromUrl(
            mediaUrl: mediaUrl, savePath: savePath);
        await appSettings.put(chatBackgroundKey, savePath);
        log.wtf('HiveSavedPath:${appSettings.get(chatBackgroundKey)}');
      }
    } catch (err) {
      log.e('Error comes in creating the folder : $err');
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
