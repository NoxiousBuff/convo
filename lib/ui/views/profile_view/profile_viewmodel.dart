import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger('ProfileViewModel');

  final bool _isUploading = false;
  bool get isUploading => _isUploading;

  int? value;

  void currentIndex(int? i) {
    value = i;
    notifyListeners();
  }

  List<String> optionName = [
    'For 15 Minutes',
    'For 1 Hour',
    'For 8 Hours',
    'For 24 Hours',
    'Until I turn it back on'
  ];

  Future<void> unBlockUser(dynamic fireUserId) async {
    await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(firestoreApi.getCurrentUser()!.uid)
        .get()
        .then((query) {
      query.reference.update({
        UserField.blockedUsers: FieldValue.arrayRemove(fireUserId),
      });
    });
  }

  Future<void> blockAndUnBlock(
      {required dynamic fireUserId,
      required String currentUserID,
      required ChatViewModel chatViewModel}) async {
    final usercollection = FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(currentUserID);

    final docSnap = await usercollection.get();
    List queue = docSnap.get(UserField.blockedUsers);

    if (queue.contains(fireUserId) == true) {
      usercollection.update({
        UserField.blockedUsers: FieldValue.arrayRemove([fireUserId])
      });
      chatViewModel.iBlockThisUserValue(false);
      log.wtf('User is unblock now !!');
    } else {
      usercollection.update({
        UserField.blockedUsers: FieldValue.arrayUnion([fireUserId])
      });
      chatViewModel.iBlockThisUserValue(true);
      log.wtf('This contact is block now !!');
    }
  }

  Future<void> blockContactDialog(
      {required FireUser fireUser,
      required String fireUserId,
      required BuildContext context,
      required ChatViewModel chatViewModel}) {
    var text =
        'Block ${fireUser.username}?\nblocked contacts will no longer send messages and you also not be able to send messages';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: activeBlue)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await blockAndUnBlock(
                        fireUserId: fireUserId,
                        chatViewModel: chatViewModel,
                        currentUserID: firestoreApi.getCurrentUser()!.uid)
                    .catchError((e) {
                  log.e('Bloack This User$e');
                });
              },
              child:
                  Text('Block', style: Theme.of(context).textTheme.bodyText2),
            ),
          ],
        );
      },
    );
  }
}
