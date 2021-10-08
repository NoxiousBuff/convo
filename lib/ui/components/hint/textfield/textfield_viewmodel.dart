// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:hint/constants/message_string.dart';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/components/media/reply/reply_back_viewmodel.dart';

class TextFieldViewModel extends BaseViewModel {
  /// If it is true then emojies will display,
  bool _blackEmojie = false;
  bool get blackEmojie => _blackEmojie;

  /// For toggling the visibility emojies [Black Emojies]
  void emojieChanger(bool emojie) {
    _blackEmojie = emojie;
    notifyListeners();
  }

  /// If it is true then memes will display
  bool _showMemes = false;
  bool get showMemes => _showMemes;

  /// For toggling the visibility memes
  void memeChanger(bool meme) {
    _showMemes = meme;
    notifyListeners();
  }

  /// If it is true then memojies will display
  bool _showMemojies = false;
  bool get showMemojies => _showMemojies;

  /// For toggling the visibility of memojies
  void toggleMemojies(bool memojie) {
    _showMemojies = memojie;
    notifyListeners();
  }

  /// For displaying PixaBay Images
  bool _showPixaBay = false;
  bool get showPixaBay => _showPixaBay;

  /// For toggle the visibility of PixaBay Images
  void pixaBayToggle(bool pixaBay) {
    _showPixaBay = pixaBay;
    notifyListeners();
  }

  /// For displaying Animal Memojies
  bool _showAnimalMemojies = false;
  bool get showAnimalMemohjies => _showAnimalMemojies;

  /// For toggle the visibility of Animal Memojies
  void animalToggle(bool animalMemojie) {
    _showAnimalMemojies = animalMemojie;
    notifyListeners();
  }

  /// Clicking Image from camera
  Future<File?> pickImage() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (selectedImage != null) {
      return File(selectedImage.path);
    } else {
      getLogger('ChatViewModel').wtf('pickImage | Image not clicked');
    }
  }

  /// Record a Video from camera
  Future<File?> pickVideo() async {
    final selectedVideo =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    if (selectedVideo != null) {
      return File(selectedVideo.path);
    } else {
      getLogger('ChatViewModel').wtf('pickVideo | Video was not recorded');
    }
  }

  Future<void> pickMedias(
      {required String boxId, required String receiverUid, required BuildContext context}) async {
    const pickFile = FileType.media;
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(type: pickFile, allowMultiple: true);
    final replyPod = context.read(replyBackProvider);
    if (result != null) {
      for (var path in result.paths) {
        if (path != null) {
          final uid = const Uuid().v1();
          final timestamp = Timestamp.now();
          final mime = lookupMimeType(path);
          final type = mime!.split('/').first;

          final videoBox = Hive.box('VideoThumbnails[$boxId]');
          final imagesBox = Hive.box('ImagesMemory[$boxId]');
          if (type == videoType) {
            Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
              video: path,
              imageFormat: ImageFormat.PNG,
            ).catchError((e){getLogger('TextField').e('Thumbnail:$e')});
            if (thumbnail != null) {
              await videoBox.put(uid, thumbnail);
              getLogger('TextField').wtf('Thumbnail:${videoBox.get(uid)}');
            } else {
              getLogger('TextField').e('Thumbnail is null now!!');
            }
          } else if (type == imageType) {
            Uint8List bytes = await File(path).readAsBytes();
            await imagesBox.put(uid, bytes);
            var memoryImage = imagesBox.get(uid);
            getLogger('TextField').wtf('MemoryImage:$memoryImage');
          }
          final replyMsg =  replyPod.message;
         !replyPod.showReply ? await chatService.addFirestoreMessage(
            type: type,
            mediaURL: path,
            messageUid: uid,
            timestamp: timestamp,
            receiverUid: receiverUid,
          ) :await chatService.addFirestoreMessage(
            type: type,
            isReply: true,
            mediaURL: path,
            messageUid: uid,
            timestamp: timestamp,
            receiverUid: receiverUid,
            replyMessage: {
              ReplyField.replyType: replyPod.messageType,
              ReplyField.replyMessageUid:replyPod.messageUid,
              ReplyField.replyMediaUrl: replyMsg != null ? replyMsg[MessageField.mediaURL] : null,
              ReplyField.replyMessageText: replyMsg!= null ? replyMsg[MessageField.messageText]: null,
            }
          )  ;
          
        } 
      }
       replyPod.showReplyBool(false);
    } else {
      getLogger('TextFieldView').w('no media was selected');
    }
  }
}
