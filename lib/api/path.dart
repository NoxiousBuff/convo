import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// class PathHelper {
//   final log = getLogger('PathApi');

//   DioApi dioApi = DioApi();
//   Directory? globalDirectory;

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }

//   Future<String?> flutterDownloader() async {
//     var savedDir = await pathFinder.getSavedDirecotyPath('Media/Convo Videos');
//     final _taskID = await FlutterDownloader.enqueue(
//         url: url, savedDir: savedDir, fileName: '$fileName.mp4');
//   }

//   Future<void> saveMediaAtPath({
//     required String mediaUrl,
//     required String mediaName,
//     required String folderPath,
//     required String messageUid,
//     required String hiveBoxName,
//   }) async {
//     Directory? directory;
//     try {
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.storage)) {
//           directory = (await getExternalStorageDirectory());
//           String newPath = "";
//           List<String> paths = directory!.path.split("/");
//           for (int x = 1; x < paths.length; x++) {
//             String folder = paths[x];
//             if (folder != "Android") {
//               newPath += "/" + folder;
//             } else {
//               break;
//             }
//           }
//           String backPath = '/Convo' '/$folderPath';
//           //todo: remove
//           log.wtf('Back Path of the Folder : $backPath');
//           newPath = newPath + backPath;
//           directory = Directory(newPath);
//           log.wtf('Path of the newly created directory : ${directory.path}');
//         } else {}
//       } else {
//         if (await _requestPermission(Permission.photos)) {
//           directory = await getApplicationDocumentsDirectory();
//         } else {}
//       }

//       String savePath = directory!.path + "/$mediaName.jpeg";
//       log.i('Save Path: $savePath');

//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }

//       if (await directory.exists()) {
//         await dioApi.downloadMediaFromUrl(
//             mediaUrl: mediaUrl, savePath: savePath);
//         await Hive.box(hiveBoxName).put(messageUid, savePath).whenComplete(
//             () => log.wtf('Media Path is saved in hive $savePath'));
//       }
//     } catch (err) {
//       log.e('Error comes in creating the folder : $err');
//     }
//   }
// }

class PathHelper {
  final log = getLogger('PathHelper');

  Directory? globalDirectory;

  /// Generate fileName for received media
  /// which will download and save locally
  String receivedMediaName(String mimeType) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    switch (mimeType) {
      case MediaType.image:
        return 'CON-$uploadingDate-IMG-$uploadingTime';

      case MediaType.video:
        return 'CON-$uploadingDate-VID-$uploadingTime';
      case MediaType.document:
        return 'CON-$uploadingDate-DOC-$uploadingTime';
      default:
        return 'CON-$uploadingDate-DOC-$uploadingTime';
    }
  }

  /// Genrate fileName which will locally saved
  String localNameGenerator(String mimeType) {
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

  String firestorePathGenerator(String mediaType, String storageFolder) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    String uploadingDate = '$year$month$day';
    String uploadingTime = '${now.second}${now.millisecond}${now.microsecond}';

    /// Generate firebase store file name
    String storagePath = mediaType == MediaType.image
        ? 'IMG-$uploadingDate-$uploadingTime.jpeg'
        : 'VID-$uploadingDate-$uploadingTime.mp4';

    final date = DateFormat('yMMMMd').format(now);
    final firebasePath = '$storageFolder/$date/$storagePath';
    return firebasePath;
  }

  /// request for get permission of storage from user if Convo don't have
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

  /// download media using flutter_downloader and return a map
  Future<Map<String, dynamic>> flutterDownloader({
    required String url,
    required String savedDir,
    required String fileNameWithExtension,
  }) async {
    // await FlutterDownloader.registerCallback(DownloadCallbackClass.callback);

    final _taskID = await FlutterDownloader.enqueue(
        url: url, savedDir: savedDir, fileName: fileNameWithExtension);

    Map<String, dynamic> _map = {
      MediaHiveBoxField.taskID: _taskID,
      MediaHiveBoxField.thumbnailPath: null,
      MediaHiveBoxField.localPath: '$savedDir/$fileNameWithExtension',
    };
    log.w('flutter downloader Return : $_map');
    return _map;
  }

  /// This will return the created local path of a file
  Future<String> _getLocalPath({
    required String mediaName,
    required String folderPath,
    required String extension,
  }) async {
    Directory? directory;

    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        directory = (await getExternalStorageDirectory());
        String directoryPath = directory!.path;
        // List<String> paths = directory!.path.split("/");
        // for (int x = 1; x < paths.length; x++) {
        //   String folder = paths[x];
        //   if (folder != "Android") {
        //     newPath += "/" + folder;
        //   } else {
        //     break;
        //   }
        // }
        // String backPath = '/$folderPath';
        //newPath = newPath + backPath;
        final path = '$directoryPath/$folderPath';
        directory = Directory(path);
        log.wtf('Android Folder Path Of Convo: $directory');
        log.wtf('Path of the newly created directory : $path');
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
        String directoryPath = directory!.path;

        // String newPath = "";
        // List<String> paths = directory!.path.split("/");
        // for (int x = 1; x < paths.length; x++) {
        //   String folder = paths[x];
        //   if (folder != "Android") {
        //     newPath += "/" + folder;
        //   } else {
        //     break;
        //   }
        // }
        // String backPath = '/Convo' '/$folderPath';
        // log.wtf('Back Path of the Folder : $backPath');
        // newPath = newPath + backPath;
        // directory = Directory(newPath);
        // log.wtf('Path of the newly created directory : ${directory.path}');
        final path = '$directoryPath/$folderPath';
        directory = Directory(path);
        log.wtf('Android Folder Path Of Convo: $directory');
        log.wtf('Path of the newly created directory : $path');
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
  Future<File> saveInLocalPath(
    File mediaFile, {

    /// The name of media which will save
    required String mediaName,

    /// The folder path where media will be saved
    required String folderPath,

    /// Extension of file that you want to save
    required String extension,
  }) async {
    final path = await _getLocalPath(
        mediaName: mediaName, folderPath: folderPath, extension: extension);
    return mediaFile.copy(path);
  }

  /// This function will save your given bytes in that path you choosed or make
  /// e.g: /storage/emulated/0/Convo/Media/Convo Images/your filename
  Future<File> saveBytesLocally(
    Uint8List bytesData, {

    /// The name of media which will save
    required String mediaName,

    /// The folder path where media will be saved
    required String folderPath,

    /// Extension of file that you want to save
    required String extension,
  }) async {
    final path = await _getLocalPath(
        mediaName: mediaName, folderPath: folderPath, extension: extension);
    final writedFile = File(path).writeAsBytes(bytesData);
    return writedFile;
  }
}
