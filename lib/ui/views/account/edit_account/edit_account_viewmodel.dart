import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/locator.dart';
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
  static const _hiveBox = HiveApi.userDataHiveBox;
  final log = getLogger('EditAccountViewModel');

  final firestoreApi = locator<FirestoreApi>();

  final FirebaseStorage _storage = FirebaseStorage.instance;
    /// upload user profile image in firebase storage
  Future uploadProfileImage(File file, BuildContext context) async {
    String userEmail = hiveApi.getUserData(FireUserField.email);
    String firestorePath = 'ProfilePhotos/$userEmail';

    setBusy(true);

    final uploadTask = _storage.ref(firestorePath).putFile(file);

    uploadTask.timeout(const Duration(seconds: 8), onTimeout: () {
      customSnackbars.errorSnackbar(context, title: 'Failed to upload image');
      return uploadTask;
    });

    uploadTask.snapshotEvents.listen(
      (event) {
        double _progress = event.bytesTransferred / event.totalBytes;
        log.v('Progress: $_progress');
      },
      onDone: () => log.v('Image was uploaded'),
      onError: (error) {
        setBusy(false);
        log.e('Error:$error');
      },
    );
    await uploadTask;
    String downloadURL = await _storage.ref(firestorePath).getDownloadURL();

    String key = FireUserField.photoUrl;
    await Hive.box(_hiveBox)
        .put(key, downloadURL)
        .whenComplete(() => log.wtf('succesfully save in hive'));

    await updateUserProperty(context, FireUserField.photoUrl, downloadURL);
  }

  Future<File?> pickImage(BuildContext context) async {
    final selectedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (selectedImage != null) {
      const title = 'Your file size is greater than 8 MB';
      final fileSizeInBytes = File(selectedImage.path).lengthSync();
      // Convert the bytes to Kilobytes (1 KB = 1024 Bytes)
      double fileSizeInKB = fileSizeInBytes / 1024;
      // Convert the KB to MegaBytes (1 MB = 1024 KBytes)
      double fileSizeInMB = fileSizeInKB / 1024;
      log.wtf('File Size: $fileSizeInMB MB');
      if (fileSizeInMB > 8.0) {
        customSnackbars.errorSnackbar(context, title: title);
      } else {
        String path = File(selectedImage.path).path;
        Navigator.pop(context);
        await uploadProfileImage(File(path), context);
      }
      return File(selectedImage.path);
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

  String _formattedBirthDate = '';
  String get formattedBirthDate => _formattedBirthDate;

  void birthDateFormatter() {
    final birthDateInMilliseconds = hiveApi.getUserData(FireUserField.dob); 
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

  Future<void> updateUserProperty(BuildContext context, String propertyName, dynamic value,{bool useSetBusy = true}) async {
    if(useSetBusy) setBusy(true);
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: value,
      propertyName: propertyName,
    )
        .then((instance) {
      hiveApi.updateUserData(propertyName, value);
      customSnackbars.successSnackbar(context,
          title: 'Succeesfully Saved !!');
    });
    if(useSetBusy) setBusy(false);
  }
}