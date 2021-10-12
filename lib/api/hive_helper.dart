// await Hive.openBox('UrlData[$conversationId]');
//     await Hive.openBox('ImagesMemory[$conversationId]');
//     await Hive.openBox("ChatRoomMedia[$conversationId]");
//     await Hive.openBox('ThumbnailsPath[$conversationId]');
//     await Hive.openBox('VideoThumbnails[$conversationId]');

import 'package:hive_flutter/hive_flutter.dart';

Box urlDataHiveBox(String conversationId) =>
    Hive.box('URLData[$conversationId]');

Box imagesMemoryHiveBox(String conversationId) =>
    Hive.box('ImagesMemory[$conversationId]');

Box chatRoomMediaHiveBox(String conversationId) =>
    Hive.box('ChatRoomMedia[$conversationId]');

Box thumbnailsPathHiveBox(String conversationId) =>
    Hive.box('ThumbnailsPath[$conversationId]');

Box videoThumbnailsHiveBox(String conversationId) =>
    Hive.box('VideoThumbnails[$conversationId]');

String urlData(String conversationId) => 'URLData[$conversationId]';

String imagesMemory(String conversationId) => 'ImagesMemory[$conversationId]';

String chatRoomMedia(String conversationId) => 'ChatRoomMedia[$conversationId]';

String thumbnailsPath(String conversationId) =>
    'ThumbnailsPath[$conversationId]';

String videoThumbnails(String conversationId) =>
    'VideoThumbnails[$conversationId]';
