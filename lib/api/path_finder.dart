import 'dart:io';
import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final pathFinder = PathFinder();

class PathFinder {
  final log = getLogger('PathFinder');

  Directory? globalDirectory;

  // * request for get permission of storage from user if Convo don't have 
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

  /// This will return the created path of a file
  Future<String> _getLocalPath({
    required String mediaName,
    required String folderPath,
    required String extension,
  }) async {
    Directory? directory;

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
        String backPath = '/Convo' '/$folderPath';
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
    return savePath;
  }

  /// This the path of saved directory
  /// saved Directory Path means
  /// The directory OR folder in which you want to saved the file
  Future<String> getSavedDirecotyPath(String folderPath) async {
    Directory? directory;

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
        String backPath = '/Convo' '/$folderPath';
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

    String savePath = directory!.path;
    log.i('Save Path: $savePath');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return savePath;
  }

  /// This function will save a copy of your given file in that path you choosed or make
  /// e.g: /storage/emulated/0/Convo/Media/Convo Images/your filename
  Future<File> saveInLocalPath(File mediaFile,
      {required String mediaName,
      required String folderPath,
      required String extension}) async {
    final path = await _getLocalPath(
        mediaName: mediaName, folderPath: folderPath, extension: extension);
    return mediaFile.copy(path);
  }
}
