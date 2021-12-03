import 'package:filesize/filesize.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/api/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hint/app/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';

class EditAccountViewModel extends BaseViewModel {
  static const _hiveBox = HiveApi.userdataHiveBox;
  final log = getLogger('EditAccountViewModel');

  TextEditingController displayNameTech = TextEditingController(text: hiveApi.getUserDataWithHive(FireUserField.displayName));
  TextEditingController userNameTech = TextEditingController(text: hiveApi.getUserDataWithHive(FireUserField.username));
  TextEditingController bioTech = TextEditingController(text: hiveApi.getUserDataWithHive(FireUserField.bio));

  Future<File?> pickImage() async {
    final file = await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .catchError((e) {
      log.e('PickImage Error:$e');
    });
    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }

  Future<String?> uploadFile(String filePath, BuildContext context) async {
    setBusy(true);
    String path = 'ProfilePhotos/';
    final size = File(filePath).readAsBytesSync().lengthInBytes;
    final kbSize = size / 1024;
    final fileSize = kbSize / 1024;
    final _size = filesize(size);
    log.wtf(_size);
    if (fileSize.toInt() > 8) {
      customSnackbars.infoSnackbar(context,
          title: 'Your file size is greater than 8 MB');
      return null;
    } else {
      customSnackbars.infoSnackbar(context, title: 'File is uploading.......');
      final downloadUrl = await storageApi.uploadFile(filePath, path, onError: () {
        customSnackbars.errorSnackbar(context, title: 'Something went wrong');
      });
      final response = await http.get(Uri.parse(downloadUrl!));
      String key = FireUserField.photoUrl;
      await Hive.box(_hiveBox).put(key, response.bodyBytes);
      log.wtf(response.bodyBytes);
      setBusy(false);
      return downloadUrl;
    }
  }
}