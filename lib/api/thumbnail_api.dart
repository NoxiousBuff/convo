import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadCallbackClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}

abstract class ThumbnailAPI extends ChangeNotifier {
  /// getLogger variable
  //final log = getLogger('VideoThumbnailViewModel');

  /// check the state of the videothumbnail class
  bool get isMounted;

  /// task id of received media
  String get taskID;

  /// downloading progress of cureently downloading media
  //int _downloadingProgress = 0;
  int get downloadingProgress;

  /// task status of media
  /// e.g completed, cancel, resume, undefine etc
  DownloadTaskStatus get taskStatus;

  /// get the state of videothumbnail class
  void getMounted(bool value);

  /// Get TaskID From Isolate
  void getTaskID(String taskIDValue);

  /// Get the progress of currently downloading media
  void getProgress(int progress);

  /// get the status of task
  void getTaskStatus(DownloadTaskStatus status);
}

class ThumbnailImplientation extends ThumbnailAPI {
  /// check the state of the videothumbnail class
  bool _isMounted = false;

  /// task id of received media
  String _taskID = '';

  /// downloading progress of cureently downloading media
  int _downloadingProgress = 0;

  /// task status of media
  /// e.g completed, cancel, resume, undefine etc
  DownloadTaskStatus _taskStatus = DownloadTaskStatus.undefined;

  @override
  bool get isMounted => _isMounted;

  /// get the state of videothumbnail class
  @override
  void getMounted(bool value) {
    _isMounted = value;
    notifyListeners();
  }

  @override
  String get taskID => _taskID;

  /// get the id of task from isolate OR thread
  @override
  void getTaskID(String taskIDValue) {
    _taskID = taskIDValue;
    notifyListeners();
  }

  @override
  int get downloadingProgress => _downloadingProgress;

  /// get the downloading progress of currently downloading media
  @override
  void getProgress(int progress) {
    _downloadingProgress = progress;
    notifyListeners();
  }

  @override
  DownloadTaskStatus get taskStatus => _taskStatus;

  /// get the status task OR media
  @override
  void getTaskStatus(DownloadTaskStatus status) {
    _taskStatus = status;
    notifyListeners();
  }
}
