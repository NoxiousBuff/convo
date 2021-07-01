import 'dart:io';
import 'package:hint/helper/dio_helper.dart';
import 'package:hint/helper/hive_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//todo : I need to figure this out for ios and web

class PathHelper {
  Directory? globalDirectory;
  HiveHelper hiveHelper = HiveHelper();
  DioHelper dioHelper = DioHelper();

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

  Future<void> createFolder({
    required String folderPath,
  }) async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory());
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          print(directory.path);
          print(paths);
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];

            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          String backPath = '/Hint' + '/$folderPath';
          //todo: remove
          print('Printing the back Path of the Folder : $backPath');
          newPath = newPath + backPath;
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
            print(
                'Printing the path of the newly created directory : ${directory.path}');
          }
        } else {}
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {}
      }
    } catch (err) {
      print('Error comes in creating the folder : $err');
    }
  }

  Future<void> saveMediaAtPath({
    required folderPath,
    required String mediaName,
    required String mediaUrl,
    required String uuid,
    required String hiveBoxName,
  }) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory());
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          print(directory.path);
          print(paths);
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          String backPath = '/Hint' + '/$folderPath';
          //todo: remove
          print('Printing the back Path of the Folder : $backPath');
          newPath = newPath + backPath;
          directory = Directory(newPath);
          print(
              'Printing the path of the newly created directory : ${directory.path}');
        } else {}
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {}
      }

      String savePath = directory!.path + "/$mediaName.jpg";
      print('Save Path: $savePath');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        await dioHelper.downloadMediaFromUrl(
            mediaUrl: mediaUrl, savePath: savePath);
        await hiveHelper.saveFilePathInHive(
            hiveBoxName: hiveBoxName, key: uuid, filePath: savePath);
      }
    } catch (err) {
      print('Error comes in creating the folder : $err');
    }
  }
}
