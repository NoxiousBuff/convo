import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentChatsViewModel extends StreamViewModel {
  final log = getLogger('RecentChatsViewModel');
  final liveUserUid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getRecentChats() {
    return _firestore
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .collection(recentFirestoreKey)
        .orderBy(DocumentField.timestamp, descending: true)
        .snapshots();
  }

  void signOut(BuildContext context) =>
      authService.signOut(context, onSignOut: () {
        getLogger('AuthService').wtf('User has been loggeed out.');
      });

  Future<bool> _requestContactsPermission() async {
    final permission = Permission.contacts;
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future getContacts() async {
    if (await _requestContactsPermission()) {
      Iterable<Contact> contacts = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      );
      List<Contact> contactList = contacts.toList();
      for (int i = 0; i < 600; i++) {
        final phones = contactList[i].phones;
        log.wtf('PhoneNumber: ${phones!.first.value.toString()}');
      }
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => getRecentChats();
}
