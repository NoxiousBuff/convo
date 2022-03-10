import 'dart:io';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class BackgroundDownloader {
  final log = getLogger('BackgroundDownloader');

  Directory? globalDirectory;
  DioApi dioApi = DioApi();
  // Future<void> _requestDownload(
  //     {required String url,
  //     required String fileName,
  //     required String localPath}) async {
  //   // final dir =
  //   //     await getApplicationDocumentsDirectory(); //From path_provider package
  //   // var _localPath = dir.path + _name;
  //   // final savedDir = Directory(_localPath);
  //   //await savedDir.create(recursive: true).then((value) async {});
  //   String? _taskid = await FlutterDownloader.enqueue(
  //     url: url,
  //     fileName: fileName,
  //     savedDir: localPath,
  //     showNotification: true,
  //     openFileFromNotification: false,
  //   );
  //   log.wtf('TaskID:$_taskid');
  // }

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

  Future<void> saveMediaAtPath({
    /// DownloadUrl of media
    required String mediaURL,

    /// Media Name without extension
    required String mediaName,

    /// Unique Id of each message
    required String messageUid,

    /// Folder Name In Which You Download The Media
    /// e.g Media, Images, Video, ConvoMedias
    required String folderPath,

    /// Extension of the downloaded Media
    required String extension,
  }) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory());
          String newPath = "";
          List<String> paths = directory!.path.split("/");

          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          String backPath = '/Convo/$folderPath';
          log.wtf('Back Path of the Folder : $backPath');
          newPath = newPath + backPath;
          directory = Directory(newPath);
          log.wtf('Path of the newly created directory : ${directory.path}');
        } else {}
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {}
      }

      String savePath = directory!.path + "/$mediaName.$extension";
      log.i('Save Path: $savePath');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        await dioApi.downloadMediaFromUrl(
            mediaUrl: mediaURL, savePath: savePath);
        await Hive.box(HiveApi.mediaHiveBox)
            .put(messageUid, savePath)
            .whenComplete(
                () => log.wtf('Media Path is saved in hive $savePath'));
      }
    } catch (err) {
      log.e('Error comes in creating the folder : $err');
    }
  }
}
