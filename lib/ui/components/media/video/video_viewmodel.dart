import 'dart:io';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class VideoViewModel extends BaseViewModel {
  final log = getLogger('VideoViewModel');

  DioApi dioApi = DioApi();
  Directory? globalDirectory;

  Future<void> uploadAndSave({
    required String filePath,
    required String messageUid,
    required String conversationId,
    required MessageBubbleViewModel model,
  }) async {
    final downloadURL = await model.uploadFile(
        filePath: filePath,
        messageUid: messageUid,
        conversationId: conversationId);

    await saveMediaPath(
      mediaURL: downloadURL,
      messageUid: messageUid,
      conversationId: conversationId,
    );
  }

  Future<void> thumbnailPath({
    required String videoPath,
    required String messageUid,
    required String thumbnailName,
    required String conversationId,
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
        String backPath = '/Hint/Media/Video Thumbnails';
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

    String savePath = directory!.path + '/$thumbnailName.jpeg';
    // String savePath = directory!.path + "/$mediaName";

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    if (await directory.exists()) {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
      ).catchError((e) {
        log.e(e);
      });
      log.wtf('savedThumbnail:$thumbnail');
      if (thumbnail != null) {
        final thumbnailPath =
            await File(savePath).writeAsBytes(thumbnail.toList());
        final hiveBox = hiveApi.thumbnailsPathHiveBox(conversationId);
        await hiveBox.put(messageUid, thumbnailPath.path);
        log.wtf('videoThumbnailPath: ${hiveBox.get(messageUid)}');
      }
    }
  }

  Future<void> saveMediaPath({
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
      conversationId: conversationId,
      folderPath: 'Media/Hint Videos',
      mediaName: 'VID-$mediaName.mp4',
    );
  }

  Future<void> savePath({
    required String mediaUrl,
    required String mediaName,
    required String folderPath,
    required String messageUid,
    required String conversationId,
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
      log.wtf('downloadVideoPath: $savePath');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        final hiveBox = hiveApi.chatRoomMediaHiveBox(conversationId);
        await dioApi.downloadMediaFromUrl(
            mediaUrl: mediaUrl, savePath: savePath);
        await hiveBox.put(messageUid, savePath);
        log.wtf('VideoPath:${hiveBox.get(messageUid)}');
        await thumbnailPath(
            videoPath: savePath,
            messageUid: messageUid,
            thumbnailName: mediaName,
            conversationId: conversationId);
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
