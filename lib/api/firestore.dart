import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirestoreApi firestoreApi = FirestoreApi();

class FirestoreApi {
  final log = getLogger('FirestoreApi');

  static final FirebaseAuth auth = FirebaseAuth.instance;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const url =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  static const String kDefaultPhotoUrl = url;

  final CollectionReference usersCollection =
      _firestore.collection(usersFirestoreKey);

  User? getCurrentUser() => auth.currentUser;

  Future<void> updateUser(
      {required String uid,
      required String updateProperty,
      required String property}) {
    return usersCollection
        .doc(uid)
        .update({property: updateProperty})
        .then((value) => getLogger('FirestoreApi')
            .wtf("$property is updated to $updateProperty"))
        .catchError((error) =>
            getLogger('FirestoreApi').e("Failed to update user: $error"));
  }

  Future<void> addToRecentList(String liveUserUid) async {
    final value = {
      RecentUserField.uid: liveUserUid,
      RecentUserField.timestamp: Timestamp.now().millisecondsSinceEpoch
    };
    await hiveApi.saveInHive(HiveApi.recentChatsHiveBox, liveUserUid, value);
  }

  Future<void> createUserInFirebase({
    Function? onError,
    required User user,
    required String country,
    required String displayName,
    required String username,
    required GeoPoint location,
    required String phoneNumber,
    required List<String> interests,
    required String countryPhoneCode,
  }) async {
    try {
      final position = GeoFirePoint(location.latitude, location.longitude).data;
      await usersCollection.doc(user.uid).set({
        FireUserField.bio: 'Hey I am using dule',
        FireUserField.country: country,
        FireUserField.countryPhoneCode: countryPhoneCode,
        FireUserField.email: user.email,
        FireUserField.hashTags: ['#Dule User'],
        FireUserField.id: user.uid,
        FireUserField.interests: interests,
        FireUserField.phone: phoneNumber,
        FireUserField.position: position,
        FireUserField.photoUrl: kDefaultPhotoUrl,
        FireUserField.displayName: displayName,
        FireUserField.userCreated: Timestamp.now(),
        FireUserField.username : username,
        FireUserField.blocked : [],
        FireUserField.blockedBy : [],
        FireUserField.romanticStatus : 'Prefer Not To Say',
        FireUserField.gender : 'Prefer Not To Say',
        FireUserField.dob : null
      });
      log.i('User has been successfully created with details $user');
      await addToRecentList(user.uid);
    } catch (e) {
      log.w('Creating user in firebase failed. Error : $e');
      if (onError != null) onError();
    }
  }

  Future<FireUser?> getUserFromFirebase(String userUid) async {
    log.i('userUid:$userUid');

    if (userUid.isNotEmpty) {
      final userDoc = await usersCollection.doc(userUid).get();
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
    final currentUser = auth.currentUser!;
    await usersCollection
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
    final currentUser = auth.currentUser!;
    await usersCollection
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
    final currentUser = auth.currentUser!;
    await usersCollection
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
