import 'dart:ui';
import 'dart:isolate';
import 'package:hint/api/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/path_finder.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
  final pathHelper = PathHelper();
  final ReceivePort _port = ReceivePort();
  final log = getLogger('DownloaderView');
  DownloadTaskStatus _taskStatus = DownloadTaskStatus.enqueued;
  String url =
      'https://firebasestorage.googleapis.com/v0/b/hint-72d23.appspot.com/o/2.%20Microsoft%20Excel%20Startup%20Screen.mp4?alt=media&token=07860ee9-7d0b-4086-9ba0-1cf947326a57';

  @override
  void initState() {
    FlutterDownloader.registerCallback(TestClass.callback);

    super.initState();
  }

  @override
  void dispose() {
    /// Remove the isolate OR dispose the isolate
    //IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  /// Get the task from flutter downloader to listen and
  /// get the info of downloading file
  Future task(String taskID) async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

    if (getTasks != null) {
      final _task = getTasks.firstWhere((task) => task.taskId == taskID);

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
      if (mounted) {
        setState(() {});
      }
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

  /// Generate fileName which will locally saved
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
    String fileName = _localNameGenerator(MediaType.video);

    var savedDir = await pathFinder.getSavedDirecotyPath('Media/Convo Videos');
    final downloaderMap = await PathHelper().flutterDownloader(
        url: url, savedDir: savedDir, fileNameWithExtension: '$fileName.mp4');

    return downloaderMap[MediaHiveBoxField.taskID];
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
          verticalSpaceMedium,
          CupertinoButton.filled(
            child: const Text('Generate Thumbnail'),
            onPressed: () async {
              //String folderPath = 'Media/Thumbnails';
              //String encodedURL = Uri.encodeFull(url);
              try {
                // var path = await pathHelper.getSavedDirecotyPath(folderPath);
                // final name = pathHelper.localNameGenerator(MediaType.image);
                // final fileName = await VideoThumbnail.thumbnailData(
                //   quality: 75,
                //   video: encodedURL,
                //   //thumbnailPath: '$path/$name.jpeg',
                // );
                // log.wtf('filename:$fileName');
                // var file =
                //     await VideoCompress.getFileThumbnail(url, quality: 50);
                // log.wtf('thumbnailPath:$file');
                // await pathHelper
                //     .saveInLocalPath(file,
                //         extension: 'jpeg',
                //         mediaName: 'MediaName',
                //         folderPath: 'Media/Thumbnails')
                //     .whenComplete(() => log.wtf('Thumbnail Saved Succesfully'));
              } on Exception catch (e) {
                log.e('Thumbnail Generate Error:$e');
              }
            },
          ),
          Text('${_downloadingProgress / 100}'),
          IconButton(
              onPressed: () => FlutterDownloader.cancel(taskId: _taskId),
              icon: const Icon(Icons.close)),
          verticalSpaceMedium,
          LinearProgressIndicator(value: _downloadingProgress / 100)
        ],
      ),
    );
  }
}
