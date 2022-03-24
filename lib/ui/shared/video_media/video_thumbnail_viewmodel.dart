import 'package:dio/dio.dart';
import 'package:hint/api/path.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/thumbnail_api.dart';
import 'package:hint/api/flutter_downloader_api.dart';

class VideoThumbnailViewModel extends BaseViewModel {
  /// Calling Path Helper API
  final pathHelper = PathHelper();

  final CancelToken _cancelToken = CancelToken();
  CancelToken get cancelToken => _cancelToken;

  int _downloadingProgress = 0;
  int get downloadingProgress => _downloadingProgress;

  /// Calling logger for better printing in console
  final log = getLogger('VideoThumbnailViewModel');

  /// Calling thumbnailAPI class locator
  final thumbnailAPI = locator.get<ThumbnailAPI>();

  /// calling flutter downloader api
  final downloadTaskAPI = locator.get<FlutterDownloaderAPI>();

  /// port for isolate to listen OR receive data from isolate also
  /// sending data into isolate
  //final ReceivePort _port = ReceivePort();

  final valueNotifier = ValueNotifier<int>(0);

  /// download media from url and save it locally
  Future downloadVideo(Uri uri, String savePath) async {
    final response = await Dio().downloadUri(
      uri,
      savePath,
      onReceiveProgress: (downloaded, total) {
        int _progress = ((downloaded / total) * 100).toInt();
        _downloadingProgress = _progress;
        valueNotifier.value == _progress;
        notifyListeners();
        log.wtf('Value Notifier:${valueNotifier.value / 100}');
        log.wtf('Downloading Progress :$_downloadingProgress');
      },
    );
    _cancelToken.cancel();
    log.wtf('Response Data:${response.data}');

    return response;
  }

  /// Get the task from flutter downloader to listen and
  /// get the info of downloading file
  // Future task(String taskID) async {
  //   List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

  //   if (getTasks != null) {
  //     final _task = getTasks.firstWhere((task) => task.taskId == taskID);

  //     thumbnailAPI.getTaskID(_task.taskId);
  //     thumbnailAPI.getProgress(_task.progress);
  //     thumbnailAPI.getTaskStatus(_task.status);
  //     updateValue(_task.progress);
  //     log.w('TaskID After Loading Tasks: ${thumbnailAPI.taskID}');
  //   } else {
  //     log.e('Task is null');
  //   }
  // }

  // /// Bind to the isolate
  // /// listen to the isolate in a stream
  // void bindBackgroundIsolate() {
  //   bool isSuccess = IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   if (!isSuccess) {
  //     unbindBackgroundIsolate();
  //     bindBackgroundIsolate();
  //     return;
  //   }
  //   _port.listen((dynamic data) {
  //     String id = data[0];
  //     DownloadTaskStatus status = data[1];
  //     int progress = data[2];
  //     if (thumbnailAPI.taskID == id) {
  //       thumbnailAPI.getTaskID(id);
  //       thumbnailAPI.getTaskStatus(status);
  //       thumbnailAPI.getProgress(progress);
  //       updateValue(progress);
  //     }
  //     log.wtf('Status:${thumbnailAPI.taskStatus}');
  //     log.d('ValueNotifier Progress:${valueNotifier.value}');
  //     log.wtf('Progress:${thumbnailAPI.downloadingProgress / 100}');
  //     if (thumbnailAPI.isMounted) notifyListeners();
  //   });

  //   //FlutterDownloader.registerCallback(DownloadCallbackClass.callback);
  // }

  // void unbindBackgroundIsolate() {
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  // }
}





// class ThumbnailAPI extends ChangeNotifier {
//   /// getLogger variable
//   final log = getLogger('VideoThumbnailViewModel');

//   /// check the state of the videothumbnail class
//   bool _isMounted = false;
//   bool get isMounted => _isMounted;

//   /// port for isolate to listen OR receive data from isolate also
//   /// sending data into isolate
//   final ReceivePort _port = ReceivePort();

//   /// task id of received media
//   String _taskID = '';
//   String get taskID => _taskID;

//   /// downloading progress of cureently downloading media
//   int _downloadingProgress = 0;
//   int get progress => _downloadingProgress;

//   /// task status of media
//   /// e.g completed, cancel, resume, undefine etc
//   DownloadTaskStatus _taskStatus = DownloadTaskStatus.undefined;
//   DownloadTaskStatus get taskStatus => _taskStatus;

//   /// get the state of videothumbnail class
//   void getMounted(bool value) {
//     _isMounted = value;
//     notifyListeners();
//   }

//   /// Get the task from flutter downloader to listen and
//   /// get the info of downloading file
//   Future task(String taskID) async {
//     List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

//     if (getTasks != null) {
//       final _task = getTasks.firstWhere((task) => task.taskId == taskID);

//       _taskID = _task.taskId;
//       _taskStatus = _task.status;
//       _downloadingProgress = _task.progress;
//       log.w('TaskID After Loading Tasks: $_taskID');
//       notifyListeners();
//     } else {
//       log.e('Task is null');
//     }
//   }

//   /// Bind to the isolate
//   /// listen to the isolate in a stream
//   void bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       if (_taskID == id) {
//         _taskStatus = status;
//         _downloadingProgress = progress;
//         notifyListeners();
//       }
//       log.wtf('Status:$_taskStatus');
//       log.wtf('Progress:${_downloadingProgress / 100}');
//       if (_isMounted) notifyListeners();
//     });
//     FlutterDownloader.registerCallback(DownloadCallbackClass.callback);
//   }

//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }
// }
