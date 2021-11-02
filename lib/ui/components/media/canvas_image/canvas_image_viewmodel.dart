import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:hint/api/dio.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hint/ui/components/media/message/message_viewmodel.dart';

class CanvasImageViewModel extends BaseViewModel {
  final log = getLogger('CanvasViewModel');

  DioApi dioApi = DioApi();
  Directory? globalDirectory;

  Future<void> uploadAndSave(
      {required Uint8List data,
      required String messageUid,
      required String conversationId,
      required MessageBubbleViewModel model}) async {
    final downloadURL = await model
        .uploadData(
      data: data,
      messageUid: messageUid,
      conversationId: conversationId,
    )
        .whenComplete(() {
      log.i('canvasImg uploaded succesfully !!');
    });
    await saveMediaPath(
      mediaURL: downloadURL,
      messageUid: messageUid,
      conversationId: conversationId,
    );
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
      mediaName: 'IMG-$mediaName.jpeg',
      folderPath: 'Media/Hint Images',
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

      String savePath = directory!.path + "/$mediaName";
      log.i('Save Path: $savePath');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        await dioApi.downloadMediaFromUrl(
            mediaUrl: mediaUrl, savePath: savePath);
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
}
