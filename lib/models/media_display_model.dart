import 'package:hint/constants/app_strings.dart';

// * Help to convert Map into Jason and vice - versa
class MediaDisplayModel {
  // * taskId is a id of that media downloaded by flutter_fownloader
  // * flutter_downloader return the taskId after downloaded the media
  // * we can get the data of that media using this taskId
  // * e.g
  // * - prgress,
  // * - resume the media where we last left to download,
  // * - cancel the downloading media, filename
  // * - and many more
  final String? taskID;
  // * the path of downloaded media locally saved in hive database
  final String localPath;
  // * Path of thumbnail also saved locally in hive database
  final String thumbnailPath;

  MediaDisplayModel.fromJson(Map<String, dynamic> json)
      : taskID = json[MediaHiveBoxField.taskID],
        localPath = json[MediaHiveBoxField.localPath],
        thumbnailPath = json[MediaHiveBoxField.thumbnailPath];

  Map<String, dynamic> toJson() => {
        MediaHiveBoxField.thumbnailPath: thumbnailPath,
        MediaHiveBoxField.localPath: localPath,
        MediaHiveBoxField.taskID: taskID,
      };
}
