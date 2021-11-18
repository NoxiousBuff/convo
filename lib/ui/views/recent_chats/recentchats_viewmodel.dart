import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/services/chat_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentChatsViewModel extends StreamViewModel<QuerySnapshot> {
  final _geo = Geoflutterfire();

  List<Contact>? _contacts;
  List<Contact>? get contacts => _contacts;

  //FireUser? _fireUser;
  late final FireUser currentFireUser;
  final _firestore = FirebaseFirestore.instance;
  final log = getLogger('RecentChatsViewModel');
  final liveUserUid = FirestoreApi.liveUserUid;

  // request permission for contacts
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

  // Get Same Interested Users For Chatting
  Future<QuerySnapshot> getUserByInterests(List<dynamic> interests) async {
    setBusy(true);
    final interestedUserList = await _firestore
        .collection(usersFirestoreKey)
        //.where(UserField.id, isNotEqualTo: liveUserUid)
        .where(UserField.interests, isGreaterThanOrEqualTo: interests)
        .get()
        .catchError((e) {
      log.e('getUserByInterests Error: $e');
    });
    int length = interestedUserList.docs.length;
    log.wtf('Length:$length');
    await Future.wait(interestedUserList.docs.map((doc) {
      final firebaseDoc = FireUser.fromFirestore(doc);
      if (firebaseDoc.id != liveUserUid) {
        return _addToSuggestionList(firebaseDoc.id);
      } else {
        return Future.error('UserUid is already in suggestion list');
      }
    }));

    setBusy(false);
    return interestedUserList;
  }

  // Adding UserUid To UserSuggestions List
  Future<void> _addToSuggestionList(String fireuserUid) async {
    try {
      final liveUserSuggestions = await _firestore
          .collection(usersFirestoreKey)
          .doc(liveUserUid)
          .collection(userSuggestionsFirestoreKey)
          .doc(fireuserUid)
          .get();

      if (!liveUserSuggestions.exists) {
        await _firestore
            .collection(usersFirestoreKey)
            .doc(liveUserUid)
            .collection(userSuggestionsFirestoreKey)
            .doc(fireuserUid)
            .set({'userUid': fireuserUid});
      } else {
        log.wtf('This FirebaseUserUid Already Exists in Suggestion List');
      }
    } catch (e) {
      log.e('_addToSuggestionList Error:$e');
    }
  }

  // Get User By Their Location
  Stream<List<DocumentSnapshot<Object?>>> getUsersByLocation(
      double latitude, double longitude) {
    setBusy(true);
    GeoFirePoint center = _geo.point(latitude: latitude, longitude: longitude);

    Query query = _firestore.collection(usersFirestoreKey);

    double radius = 50;
    String field = UserField.position;

    Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: query)
        .within(center: center, radius: radius, field: field, strictMode: true);

    stream.listen((data) {
      log.wtf('DataLength:${data.length}');
    });
    setBusy(false);
    return stream;
  }

  // get contacts from user device
  Future<void> getContacts() async {
    bool permitted = await _requestContactsPermission();
    if (permitted) {
      List<Contact> contacts = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      );
      _contacts = contacts;
      notifyListeners();
    } else {
      log.wtf('Permission is not granted');
    }
  }

  // For checking phone number exists in database
  // If phoneNumber exists in firebase this will return true, if not then return false
  Future<bool> getFireUser(String phoneNumber) async {
    final firebstoreUser = await FirebaseFirestore.instance
        .collection(phoneNumbersFirestoreKey)
        .doc(phoneNumber)
        .get()
        .catchError((e) {
      log.e('_existsInFirestore Error:$e');
    });

    if (firebstoreUser.exists) {
      log.v('Exists in firebase');
      // final fireUser = FireUser.fromFirestore(firebstoreUser);
      //log.wtf(fireUser.email);
      return true;
    } else {
      log.wtf('Not exists firebase');
      //log.wtf(firebstoreUser.docs.isNotEmpty);
      return false;
    }
  }

  Future<void> _savePhoneNumberInHive(String key, Map<String, dynamic> value) {
    return hiveApi
        .saveInHive(HiveHelper.phoneNumberHiveBox, key, value)
        .catchError((e) {
      log.e('_savePhoneNumberInHive Error:$e');
    }).whenComplete(() => log.wtf('Phone Number is Saved In Hive'));
  }

  // Get User Contacts and Save In Hive
  Future<void> gettingPhoneNumbers() async {
    setBusy(true);
    await getContacts();
    if (contacts != null) {
      for (var contact in _contacts!) {
        List<Item>? phones = contact.phones;
        if (phones != null && phones.isNotEmpty) {
          final mergedPhones = Set.of(phones.toList()).toList();
          for (var phone in mergedPhones) {
            String number = phone.value.toString();
            String formattedNumber = _numberFormatter(number);
            String key = formattedNumber;
            //log.wtf('NumberFormatter:$formattedNumber');
            Map<String, dynamic> value = {
              PhoneNumberField.number: formattedNumber,
              PhoneNumberField.contactName: contact.displayName ?? 'No Name'
            };
            if (!Hive.box(HiveHelper.phoneNumberHiveBox).containsKey(key)) {
              await _savePhoneNumberInHive(key, value)
                  .whenComplete(() => log.wtf('PhoneNumber:$formattedNumber'));
            }
          }
        }
      }
    }
    setBusy(false);
  }

  // Format the phone numbers in number based-string without country code
  String _numberFormatter(String number) {
    //Stopwatch stopwatch = Stopwatch()..start();
    const countryCodePattern =
        r'\+(?:998|996|995|994|993|992|977|976|975|974|973|972|971|970|968|967|966|965|964|963|962|961|960|886|880|856|855|853|852|850|692|691|690|689|688|687|686|685|683|682|681|680|679|678|677|676|675|674|673|672|670|599|598|597|595|593|592|591|590|509|508|507|506|505|504|503|502|501|500|423|421|420|389|387|386|385|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|291|290|269|268|267|266|265|264|263|262|261|260|258|257|256|255|254|253|252|251|250|249|248|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|218|216|213|212|211|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44\D?1624|44\D?1534|44\D?1481|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1\D?939|1\D?876|1\D?869|1\D?868|1\D?849|1\D?829|1\D?809|1\D?787|1\D?784|1\D?767|1\D?758|1\D?721|1\D?684|1\D?671|1\D?670|1\D?664|1\D?649|1\D?473|1\D?441|1\D?345|1\D?340|1\D?284|1\D?268|1\D?264|1\D?246|1\D?242|1)\D?';
    final String formattedNumber = number
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(RegExp(r"\s+"), "")
        .replaceAll('-', '')
        .replaceAll(RegExp(countryCodePattern), '');
    //log.wtf('NumberFormatter:${stopwatch.elapsedMicroseconds}');

    return formattedNumber;
  }

  Future<FireUser> getCurrentFireUser(String liveUserUid) async {
    final firestoreUser = await FirebaseFirestore.instance
        .collection(usersFirestoreKey)
        .doc(liveUserUid)
        .get();
    final _fireUser = FireUser.fromFirestore(firestoreUser);
    currentFireUser = _fireUser;
    notifyListeners();
    return _fireUser;
  }

  @override
  Stream<QuerySnapshot<Object?>> get stream => chatService.getRecentChatList();
}
