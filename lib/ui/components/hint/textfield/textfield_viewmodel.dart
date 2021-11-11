// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/components/media/reply/reply_back_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TextFieldViewModel extends BaseViewModel {
  final log = getLogger('TextFieldViewModel');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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
      log.wtf('pickImage | Image not clicked');
    }
  }

  /// Record a Video from camera
  Future<File?> pickVideo() async {
    final selectedVideo =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    if (selectedVideo != null) {
      return File(selectedVideo.path);
    } else {
      log.wtf('pickVideo | Video was not recorded');
    }
  }

  void Function() textFieldMessage({
    required bool connected,
    required String receiverUid,
    required BuildContext context,
    required String conversationId,
    required ChatViewModel chatViewModel,
    required TextEditingController controller,
  }) =>
      () async {
        final timestamp = Timestamp.now();
        final replyPod = context.read(replyBackProvider);
        String messageUid = const Uuid().v1();
        bool isUrl = isURL(controller.text);
        var replyMsg = replyPod.message;
        !replyPod.showReply
            ? await chatService.addFirestoreMessage(
                timestamp: timestamp,
                messageUid: messageUid,
                receiverUid: receiverUid,
                messageText: controller.text,
                type: isUrl ? urlType : textType,
                userBlockMe: chatViewModel.userBlockMe,
              )
            : await chatService.addFirestoreMessage(
                isReply: true,
                timestamp: timestamp,
                messageUid: messageUid,
                receiverUid: receiverUid,
                messageText: controller.text,
                type: isUrl ? urlType : textType,
                userBlockMe: chatViewModel.userBlockMe,
                replyMessage: {
                  ReplyField.replyType: replyPod.messageType,
                  ReplyField.replyMessageUid: replyPod.messageUid,
                  ReplyField.replySenderUid: replyPod.replySenderID,
                  ReplyField.replyMediaUrl:
                      replyMsg != null ? replyMsg[MessageField.mediaURL] : null,
                  ReplyField.replyMessageText: replyMsg != null
                      ? replyMsg[MessageField.messageText]
                      : null,
                },
              );
        controller.clear();
        replyPod.showReplyBool(false);
      };

  Future addMessage(
      String path, String boxId, String receiverUid, bool userBlockMe) async {
    String messageUid = const Uuid().v1();
    final mime = lookupMimeType(path);
    final type = mime!.split('/').first;

    final imagesBox = imagesMemoryHiveBox(boxId);
    Uint8List bytes = await File(path).readAsBytes();
    await imagesBox.put(messageUid, bytes);
    var memoryImage = imagesBox.get(messageUid);
    log.wtf('MemoryImage:$memoryImage');

    return chatService.addFirestoreMessage(
      type: type,
      messageUid: messageUid,
      receiverUid: receiverUid,
      timestamp: Timestamp.now(),
      userBlockMe: userBlockMe,
    );
  }

  Future<void> pickMedias({
    required String boxId,
    required String receiverUid,
    required BuildContext context,
    required ChatViewModel chatViewModel,
  }) async {
    const pickFile = FileType.media;
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(type: pickFile, allowMultiple: true);

    if (result != null) {
      for (var path in result.paths) {
        if (path != null) {
          String messageUid = const Uuid().v1();
          final mime = lookupMimeType(path);
          final type = mime!.split('/').first;

          final imagesBox = imagesMemoryHiveBox(boxId);
          Uint8List bytes = await File(path).readAsBytes();
          await imagesBox.put(messageUid, bytes);
          var memoryImage = imagesBox.get(messageUid);
          log.wtf('MemoryImage:$memoryImage');

          await chatService
              .addFirestoreMessage(
                  type: type,
                  mediaURL: path,
                  messageUid: messageUid,
                  receiverUid: receiverUid,
                  timestamp: Timestamp.now(),
                  userBlockMe: chatViewModel.userBlockMe)
              .catchError((e) {
            log.e('PickMedias Error:$e');
          }).then((value) => log.wtf('Message Added in Firestore'));
        }
      }
    }

    // if (result != null) {
    //   for (var path in result.paths) {
    //     if (path != null) {
    //       final uid = const Uuid().v1();
    //       final timestamp = Timestamp.now();
    //       final mime = lookupMimeType(path);
    //       final type = mime!.split('/').first;

    //       final videoBox = videoThumbnailsHiveBox(boxId);
    //       final imagesBox = imagesMemoryHiveBox(boxId);
    //       if (type == videoType) {
    //         Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
    //           video: path,
    //           imageFormat: ImageFormat.PNG,
    //         ).catchError((e){log.e('Thumbnail:$e')});
    //         if (thumbnail != null) {
    //           await videoBox.put(uid, thumbnail);
    //           log.wtf('Thumbnail:${videoBox.get(uid)}');
    //         } else {
    //          log.e('Thumbnail is null now!!');
    //         }
    //       } else if (type == imageType) {
    //         Uint8List bytes = await File(path).readAsBytes();
    //         await imagesBox.put(uid, bytes);
    //         var memoryImage = imagesBox.get(uid);
    //         log.wtf('MemoryImage:$memoryImage');
    //       }
    //       final replyMsg =  replyPod.message;
    //      !replyPod.showReply ? await chatService.addFirestoreMessage(
    //         type: type,
    //         mediaURL: path,
    //         messageUid: uid,
    //         timestamp: timestamp,
    //         receiverUid: receiverUid,
    //         userBlockMe: chatViewModel.userBlockMe,
    //       ) :await chatService.addFirestoreMessage(
    //         type: type,
    //         isReply: true,
    //         mediaURL: path,
    //         messageUid: uid,
    //         timestamp: timestamp,
    //         receiverUid: receiverUid,
    //         userBlockMe: chatViewModel.userBlockMe,
    //         replyMessage: {
    //           ReplyField.replyType: replyPod.messageType,
    //           ReplyField.replyMessageUid:replyPod.messageUid,
    //           ReplyField.replyMediaUrl: replyMsg != null ? replyMsg[MessageField.mediaURL] : null,
    //           ReplyField.replyMessageText: replyMsg!= null ? replyMsg[MessageField.messageText]: null,
    //         }
    //       )  ;

    //     }
    //   }
    //    replyPod.showReplyBool(false);
    // } else {
    //   log.w('no media was selected');
    // }
  }
}