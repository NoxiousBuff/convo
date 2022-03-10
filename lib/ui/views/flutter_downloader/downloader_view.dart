import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/path_finder.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

const debug = true;

// class DownloadCallbackClass {
//   static void callback(String id, DownloadTaskStatus status, int progress) {
//     final SendPort send =
//         IsolateNameServer.lookupPortByName('downloader_send_port')!;
//     send.send([id, status, progress]);
//   }
// }

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}

class DownloaderView extends StatefulWidget {
  const DownloaderView({Key? key}) : super(key: key);

  @override
  State<DownloaderView> createState() => _DownloaderViewState();
}

class _DownloaderViewState extends State<DownloaderView> {
  String _taskId = '';
  int _downloadingProgress = 0;
  List<Map> downloadsListMaps = [];
  final ReceivePort _port = ReceivePort();
  final log = getLogger('DownloaderView');
  DownloadTaskStatus _taskStatus = DownloadTaskStatus.enqueued;

  @override
  void initState() {
    flutterDownloaderInitialise();
    super.initState();
  }

  void flutterDownloaderInitialise() async {
    /// Initialise flutter downloader plugin
    await FlutterDownloader.initialize(debug: true);

    FlutterDownloader.registerCallback(TestClass.callback);
  }

  @override
  void dispose() {
    /// Remove the isolate OR dispose the isolate
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  /// Get the task from flutter downloader to listen OR
  /// get the info of downloading file
  Future task(String taskID) async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

    if (getTasks != null) {
      final _task = getTasks.firstWhere((task) => task.taskId == taskID);

      // _map['id'] = _task.taskId;
      // _map['status'] = _task.status;
      // _map['progress'] = _task.progress;
      // _map['filename'] = _task.filename;
      // _map['savedDirectory'] = _task.savedDir;

      _taskId = _task.taskId;
      _taskStatus = _task.status;
      _downloadingProgress = _task.progress;
      log.w('TaskID After Loading Tasks: $_taskId');
      setState(() {});
    } else {
      log.e('Task is null');
    }
  }

  /// Bind to the isolate
  /// listen to the isolate in a stream
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (_taskId == id) {
        _taskStatus = status;
        _downloadingProgress = progress;
      }
      log.wtf('Progress:${progress / 100}');
      log.wtf(_taskStatus);
      setState(() {});
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Widget downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? const Text('Download canceled')
        : _status == DownloadTaskStatus.complete
            ? const Text('Download completed')
            : _status == DownloadTaskStatus.failed
                ? const Text('Download failed')
                : _status == DownloadTaskStatus.paused
                    ? const Text('Download paused')
                    : _status == DownloadTaskStatus.running
                        ? const Text('Downloading.......')
                        : const Text('Download waiting');
  }

  /// This is a callback for second thread to download the file
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  /// Genrate fileName which will locally saved
  String _localNameGenerator(String mimeType) {
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

  /// download a file in background usingg flutter downloader
  Future<String?> download() async {
    const String url =
        'https://firebasestorage.googleapis.com/v0/b/hint-72d23.appspot.com/o/2.%20Microsoft%20Excel%20Startup%20Screen.mp4?alt=media&token=07860ee9-7d0b-4086-9ba0-1cf947326a57';

    String fileName = _localNameGenerator(MediaType.video);

    var savedDir = await pathFinder.getSavedDirecotyPath('Media/Convo Videos');
    final _taskID = await FlutterDownloader.enqueue(
        url: url, savedDir: savedDir, fileName: '$fileName.mp4');
    return _taskID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton.filled(
            child: const Text('Download Media'),
            onPressed: () async {
              final String? _taskID = await download();
              log.w('TaskID DownloadButton:$_taskID');
              if (_taskID != null) {
                task(_taskID);
                _bindBackgroundIsolate();
                FlutterDownloader.registerCallback(TestClass.callback);
              }
            },
          ),
          Text('${_downloadingProgress / 100}'),
          IconButton(
              onPressed: () => FlutterDownloader.cancel(taskId: _taskId),
              icon: const Icon(Icons.close)),

          // Row(
          //   children: [
          //     Text('${_downloadingProgress / 100}'),
          //     IconButton(
          //         onPressed: () => FlutterDownloader.remove(taskId: taskId),
          //         icon: icon)
          //   ],
          // ),
          verticalSpaceMedium,
          LinearProgressIndicator(value: _downloadingProgress / 100)
          // SizedBox(
          //   width: screenWidth(context),
          //   height: screenHeightPercentage(context, percentage: 0.5),
          //   child: ListView.builder(
          //       itemCount: downloadsListMaps.length,
          //       itemBuilder: (context, i) {
          //         Map _map = downloadsListMaps[i];
          //         String _filename = _map['filename'];
          //         int _progress = _map['progress'];
          //         return Column(
          //           children: [
          //             Text(_filename),
          //             verticalSpaceRegular,
          //             LinearProgressIndicator(value: _progress / 100),
          //           ],
          //         );
          //       }),
          // )
        ],
      ),
    );
  }
}
