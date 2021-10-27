import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentChatsViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('RecentChatsViewModel');
  final liveUserUid = FirebaseAuth.instance.currentUser!.uid;

  late final FireUser currentFireUsser;

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

  Future<FireUser> getCurrentFireUser(String liveUserUid) async {
    final firestoreUser = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .get();
    final _fireUser = FireUser.fromFirestore(firestoreUser);
    currentFireUsser = _fireUser;
    notifyListeners();
    return _fireUser;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => chatService.getRecentChatList();
}
