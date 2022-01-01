import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';

class InterestToggleButton extends StatelessWidget {
  final String interestName;
  InterestToggleButton(this.interestName, {Key? key}) : super(key: key);

  final firestoreApi = locator<FirestoreApi>();

  Future<void> addUserSelectedInterests(
      BuildContext context, List<dynamic> userSelectedInterests) async {
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: FieldValue.arrayUnion([interestName]),
      propertyName: FireUserField.interests,
    )
        .then((value) {
      hiveApi.updateUserData(FireUserField.interests, userSelectedInterests);
      customSnackbars.successSnackbar(context,
          title: 'You Data Was Sucessfully Saved');
    });
  }

  Future<void> removeUserSelectedInterests(
      BuildContext context, List<dynamic> userSelectedInterests) async {
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: FieldValue.arrayRemove([interestName]),
      propertyName: FireUserField.interests,
    )
        .then((value) {
      hiveApi.updateUserData(FireUserField.interests, userSelectedInterests);
      customSnackbars.successSnackbar(context,
          title: 'You Data Was Sucessfully Saved');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
      builder: (context, userDataBox, child) {
        List hiveInterests = userDataBox.get(FireUserField.interests);
        bool isAdded = hiveInterests.contains(interestName);
        return InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            try {
              if (isAdded) {
                hiveInterests.remove(interestName);
                removeUserSelectedInterests(context, hiveInterests);
              } else {
                hiveInterests.add(interestName);
                addUserSelectedInterests(context, hiveInterests);
              }
            } catch (e) {
              customSnackbars.errorSnackbar(context,
                  title: 'Something went wrong');
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isAdded
                  ? Theme.of(context).colorScheme.lightGrey
                  : Theme.of(context).colorScheme.blue,
            ),
            child: Text(
              isAdded ? 'Remove' : 'Add',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}
