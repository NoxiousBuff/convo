import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/model_string.dart';
import 'package:hint/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const int kDefaultColorCode = 0xff0071a0;
  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';
  CollectionReference subsCollection =
      _firestore.collection(subsFirestoreKey);
  Future<void> createUserInFirebase(
      {required 
      User user, String? userName, Function? onError}) async {
    try {
      
      await subsCollection.doc(user.uid).set({
        // 'id': user.uid,
        // 'username': userName,
        // 'photoUrl': kDefaultPhotoUrl,
        // 'email': user.email,
        // 'bio': '',
        // 'status': '',
        // 'userCreated': Timestamp.now(),
        // 'lastSeen': null,
        // 'phone': null
        FireUserStrings.id: user.uid,
        FireUserStrings.username: userName,
        FireUserStrings.photoUrl: kDefaultPhotoUrl,
        FireUserStrings.email: user.email,
        FireUserStrings.bio : 'Hey There , This is not empty now so I am am happy. See You after sometuime. Till then bye.',
        FireUserStrings.status: 'Talking To someone else',
        FireUserStrings.userCreated: Timestamp.now(),
        FireUserStrings.lastSeen : null,
        FireUserStrings.phone: null,
        FireUserStrings.colorHexCode : kDefaultColorCode,
        FireUserStrings.country: 'India',
        FireUserStrings.interests: ['flutter', 'coding', 'wasting my time'],
      });
      log.i('User has been successfully created with details $user');
    } catch (e) {
      log.w('Creating user in firebase failed. Error : $e');
      onError!();
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

  Future<void> changeUserDisplayName(String username) async {
    final currentUser = _auth.currentUser!;
    await subsCollection
        .doc(currentUser.uid)
        .update({'username': username})
        .then((value) => log.i(
            'User display name : $username has been successfully changed in firestore.'))
        .onError((error, stackTrace) {
          log.w(
              'There has been an error in changing username : $username in firebase.');
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