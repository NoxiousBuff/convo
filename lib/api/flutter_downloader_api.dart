import 'dart:ui';
import 'dart:isolate';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadCallbackClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}

abstract class FlutterDownloaderAPI extends ChangeNotifier {
  /// creating a port to send or listen between isolates
  ReceivePort get port;

  /// This is the list of map
  /// where all flutter downloader tasks are saved
  /// we can get info of each tasks which was runned OR currently running
  List<Map> get downloadTask;

  /// connect the isplate to main thread
  void bindBackgroundIsolate();

  /// disconnect the isolate from main thread
  void unbindBackgroundIsolate();

  /// get and add the info of tasks in the list [downloadsListMaps]
  Future task();
}

class FlutterDownloaderImplimentation extends FlutterDownloaderAPI {
  /// This is the list of map
  /// where all flutter downloader tasks are saved
  /// we can get info of each tasks which was runned OR currently running
  final List<Map> _downloadTask = [];

  /// creating a port to send or listen between isolates
  final ReceivePort _port = ReceivePort();

  @override
  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (isSuccess == false) {
      unbindBackgroundIsolate();
      //bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      var task =
          _downloadTask.where((task) => task[DownloadTaskField.taskID] == id);
      for (var element in task) {
        element[DownloadTaskField.progress] = progress;
        element[DownloadTaskField.status] = status;
        notifyListeners();
        log('Listen Status:$status');
        log('Listen Progress:$progress');
      }
    });
    FlutterDownloader.registerCallback(DownloadCallbackClass.callback);
  }

  @override
  ReceivePort get port => _port;

  @override
  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  List<Map> get downloadTask => _downloadTask;

  @override
  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

    for (var _task in getTasks!) {
      Map _map = {};
      _map[DownloadTaskField.status] = _task.status;
      _map[DownloadTaskField.progress] = _task.progress;
      _map[DownloadTaskField.taskID] = _task.taskId;
      _map[DownloadTaskField.fileName] = _task.filename;
      _map[DownloadTaskField.savedDirectory] = _task.savedDir;
      _downloadTask.add(_map);
    }
    notifyListeners();
  }
}
