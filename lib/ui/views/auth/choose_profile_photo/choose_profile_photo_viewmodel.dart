import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/home/home_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChooseProfilePhotoViewModel extends BaseViewModel {
  final log = getLogger('ChooseProfilePhotoViewModel');

  final bool shouldNavigateToHomeView;

  ChooseProfilePhotoViewModel(this.shouldNavigateToHomeView);

  final firestoreApi = locator<FirestoreApi>();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  double imageWidth(BuildContext context) {
    final width = screenWidth(context) - 50;
    return width;
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
        await uploadProfileImage(File(path), context);
      }
      return File(selectedImage.path);
    } else {
      log.wtf('pickImage | Image not clicked');
    }
  }

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
    await Hive.box(HiveApi.userDataHiveBox)
        .put(key, downloadURL)
        .whenComplete(() => log.wtf('succesfully save in hive'));

    await updateUserProperty(context, FireUserField.photoUrl, downloadURL);
  }

  Future<void> updateUserProperty(BuildContext context, String propertyName, dynamic value, {bool useSetBusy = true}) async {
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
          title: 'Profile Photo Updated');
      shouldNavigateToHomeView ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (route) => false) : Navigator.pop(context);
    });
    if(useSetBusy) setBusy(false);
  }

}