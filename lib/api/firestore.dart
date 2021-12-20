import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/services/auth_service.dart';

class FirestoreApi {
  /// abstraction of logger for providing logs in
  /// the console for this particular class
  final log = getLogger('FirestoreApi');


  ///private field [_auth] to get instance of [FirebaseAuth]
  static final FirebaseAuth _auth = FirebaseAuth.instance;


  ///private field [_auth] to get instance of [FirebaseFirestore]
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  ///default url that would be placed as their profile photo
  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';


  ///reference to the subsCollection - [Collections that stores the subs]
  final CollectionReference subsCollection =
      _firestore.collection(subsFirestoreKey);

  
  ///getter tp get the current user
  User? get getCurrentUser => _auth.currentUser;

  ///method to updateUser in [Firebase]
  Future<void> updateUser(
      {required String uid,
      required dynamic value,
      required String propertyName}) {
    return subsCollection
        .doc(uid)
        .update({propertyName: value})
        .then((instance) =>
            getLogger('FirestoreApi').wtf("$propertyName is updated to $value"))
        .catchError((error) =>
            getLogger('FirestoreApi').e("Failed to update user: $error"));
  }

  /// Update Recent User
  Future<void> updateRecentUser({
    required dynamic value,
    required String fireUserUid,
    required String propertyName,
  }) async {
    subsCollection
        .doc(AuthService.liveUser!.uid)
        .collection(recentFirestoreKey)
        .doc(fireUserUid)
        .update({propertyName: value});
  }
  
  /// Delete User Only From Recent
  Future<void> deleteOnlyRecent(String fireUserUid) async {
    await subsCollection
        .doc(AuthService.liveUser!.uid)
        .collection(recentFirestoreKey)
        .doc(fireUserUid)
        .delete();
  }



  Future<void> saveUserDataInHive(String key, dynamic userData) async {
    await hiveApi.save(HiveApi.userDataHiveBox, key, userData);
  }

  Future<void> createUserInFirebase({
    Function? onError,
    required User user,
    required String country,
    required String displayName,
    required String username,
    required String phoneNumber,
    required List<String> interests,
    required String countryPhoneCode,
  }) async {
    try {
      await subsCollection.doc(user.uid).set({
        FireUserField.bio: 'Hey I am using dule',
        FireUserField.country: country,
        FireUserField.countryPhoneCode: countryPhoneCode,
        FireUserField.email: user.email,
        FireUserField.hashTags: ['#Dule User'],
        FireUserField.id: user.uid,
        FireUserField.interests: interests,
        FireUserField.phone: phoneNumber,
        FireUserField.photoUrl: kDefaultPhotoUrl,
        FireUserField.displayName: displayName,
        FireUserField.userCreated: Timestamp.now(),
        FireUserField.username: username,
        FireUserField.blocked: [],
        FireUserField.blockedBy: [],
        FireUserField.romanticStatus: 'Prefer Not To Say',
        FireUserField.gender: 'Prefer Not To Say',
        FireUserField.dob: null
      });
      saveUserDataInHive(FireUserField.bio, 'Hey I am using dule');
      saveUserDataInHive(FireUserField.country, country);
      saveUserDataInHive(FireUserField.countryPhoneCode, countryPhoneCode);
      saveUserDataInHive(FireUserField.email, user.email);
      saveUserDataInHive(
          FireUserField.hashTags, ['#duleuser', '#new', '#available']);
      saveUserDataInHive(FireUserField.id, user.uid);
      saveUserDataInHive(FireUserField.interests, interests);
      saveUserDataInHive(FireUserField.phone, phoneNumber);
      saveUserDataInHive(
        FireUserField.photoUrl,
        kDefaultPhotoUrl,
      );
      saveUserDataInHive(
        FireUserField.displayName,
        displayName,
      );
      saveUserDataInHive(
        FireUserField.userCreated,
        Timestamp.now().millisecondsSinceEpoch,
      );
      saveUserDataInHive(
        FireUserField.username,
        username,
      );
      saveUserDataInHive(
        FireUserField.blocked,
        [],
      );
      saveUserDataInHive(
        FireUserField.blockedBy,
        [],
      );
      saveUserDataInHive(
        FireUserField.romanticStatus,
        'Prefer Not To Say',
      );
      saveUserDataInHive(
        FireUserField.gender,
        'Prefer Not To Say',
      );
      saveUserDataInHive(FireUserField.dob, null);
      log.i('User has been successfully created with details $user');
    } catch (e) {
      log.w('Creating user in firebase failed. Error : $e');
      if (onError != null) onError();
    }
  }

  Future<FireUser?> getUserFromFirebase(String userUid) async {
    log.i('userUid:$userUid');

    if (userUid.isNotEmpty) {
      final userDoc = await subsCollection.doc(userUid).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userUid in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return FireUser.fromFirestore(userDoc);
    } else {
      log.wtf('User cannot be empty. Please fill it correctly.');
    }
  }

  Future<void> changeUserName(String userName) async {
    final currentUser = _auth.currentUser!;
    await subsCollection
        .doc(currentUser.uid)
        .update({'userName': userName})
        .then((value) => log.i(
            'Username : $userName has been successfully changed in firestore.'))
        .onError((error, stackTrace) {
          log.w(
              'There has been an error in changing userName : $userName in firebase.');
        });
  }

  Future<void> changeUserDisplayName(String displayName) async {
    final currentUser = _auth.currentUser!;
    await subsCollection
        .doc(currentUser.uid)
        .update({'displayName': displayName})
        .then((value) => log.i(
            'User display name : $displayName has been successfully changed in firestore.'))
        .onError((error, stackTrace) {
          log.w(
              'There has been an error in changing displayName : $displayName in firebase.');
        });
  }

  Future<void> changeUserPhoneNumber(String phoneNumber) async {
    final currentUser = _auth.currentUser!;
    await subsCollection
        .doc(currentUser.uid)
        .update({'phone': phoneNumber})
        .then((value) => log.i(
            'User Phone Number : $phoneNumber has been successfully changed in firestore.'))
        .onError((error, stackTrace) {
          log.w(
              'There has been an error in changing user phone number : $phoneNumber in firebase.');
        });
  }
}
