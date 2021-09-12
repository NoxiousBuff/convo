import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  final log = getLogger('FirestoreApi');
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference usersCollection =
      _firestore.collection(usersFirestoreKey);

  Future<void> createUserInFirebase(
      {required User user, String? userName, Function? onError}) async {
    try {
      await usersCollection.doc(user.uid).set({
        'id': user.uid,
        'username': userName,
        'photoUrl': kDefaultPhotoUrl,
        'email': user.email,
        'bio': '',
        'status': '',
        'userCreated': Timestamp.now(),
        'lastSeen': null,
        'phone': null
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

  Future<void> changeUserDisplayName(String username) async {
    final currentUser = _auth.currentUser!;
    await usersCollection
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