import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class ContactsViewModel extends FutureViewModel {
  Iterable<Contact>? _contacts;
  Iterable<Contact>? get contacts => _contacts;

  void updateContacts(Iterable<Contact> contact) {
    _contacts = contact;
    notifyListeners();
  }

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

  Future<void> getContacts() async {
    if (await _requestContactsPermission()) {
      final Iterable<Contact> localContacts =
          await ContactsService.getContacts(withThumbnails: false, photoHighResolution: false);
      updateContacts(localContacts);
    }
  }

  @override
  Future futureToRun() => getContacts();
}
