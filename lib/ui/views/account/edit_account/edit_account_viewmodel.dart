import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/api/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';

class EditAccountViewModel extends BaseViewModel {
  static const _hiveBox = HiveApi.userdataHiveBox;
  final log = getLogger('EditAccountViewModel');

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

  String _formattedBirthDate = '';
  String get formattedBirthDate => _formattedBirthDate;

  void birthDateFormatter() {
    final birthDateInMilliseconds = hiveApi.getUserDataWithHive(FireUserField.dob); 
    if(birthDateInMilliseconds != null) {
      final dobAsInt = birthDateInMilliseconds as int;
      final dobAsDateTime = DateTime.fromMillisecondsSinceEpoch(dobAsInt);
      final jiffyFormattedDate = Jiffy(dobAsDateTime).format("MMM do yyyy");
      _formattedBirthDate = jiffyFormattedDate;
      notifyListeners();
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
      // final response = await http.get(Uri.parse(downloadUrl!));
      String key = FireUserField.photoUrl;
      await Hive.box(_hiveBox).put(key, downloadUrl);
      // log.wtf(response.bodyBytes);
      setBusy(false);
      return downloadUrl;
    }
  }

  Future<void> updateUserProperty(BuildContext context, String propertyName, dynamic value) async {
    setBusy(true);
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: value,
      propertyName: propertyName,
    )
        .then((instance) {
      hiveApi.updateUserdateWithHive(propertyName, value);
      customSnackbars.successSnackbar(context,
          title: 'Succeesfully Saved !!');
    });
    setBusy(false);
  }
}