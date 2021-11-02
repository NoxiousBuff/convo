// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PixaBayImageViewModel extends BaseViewModel {
  double _progress = 0.0;
  double get downloadingProgress => _progress;

  final bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  final log = getLogger('PixaBayImageViewModel');

  Future<void> downloadAndSavePath({
    required String mediaURL,
    required String messageUid,
    required String conversationId,
  }) async {
    final now = DateTime.now();
   final firstPart = '${now.year}${now.month}${now.day}';
    final secondPart =
        '${now.hour}${now.minute}${now.second}${now.millisecond}${now.microsecond}';
    final mediaName = '$firstPart-H$secondPart';
    log.wtf('mediaName:$mediaName');
    await savePath(
      mediaUrl: mediaURL,
      messageUid: messageUid,
      folderPath: 'Media/Hint Images',
      mediaName: 'IMG-$mediaName.jpeg',
      hiveBoxName: hiveApi.chatRoomMedia(conversationId),
    );
  }

  Future<void> savePath({
    required String mediaUrl,
    required String mediaName,
    required String folderPath,
    required String messageUid,
    required String hiveBoxName,
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
        await downloadMediaFromUrl(mediaUrl: mediaUrl, savePath: savePath);
        await Hive.box(hiveBoxName).put(messageUid, savePath);
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

  Future<void> downloadMediaFromUrl({
    required String mediaUrl,
    required String savePath,
  }) async {
    setBusyForObject(_isDownloading, true);
    await Dio()
        .download(mediaUrl, savePath, deleteOnError: true,
            onReceiveProgress: (downloaded, total) {
          final progress = downloaded / total;
          _progress = progress;
          notifyListeners();
          print('Downloading Media Progress $progress');
        })
        .then((value) => getLogger('DioApi').i(
            'The file with mediaUrl : $mediaUrl has been successfully downloaded at savePath : $savePath.'))
        .catchError((err) {
        log.w(
              'There has been a problem with downloading a file. Error : $err');
         log.w('MediaUrl: $mediaUrl and savePath: $savePath');
        });
    setBusyForObject(_isDownloading, false);
  }
}
