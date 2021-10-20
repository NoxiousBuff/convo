import 'package:hint/app/app_logger.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirestoreApi firestoreApi = FirestoreApi();

class FirestoreApi {
  final log = getLogger('FirestoreApi');
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final String liveUserUid = auth.currentUser!.uid;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const url =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';
  static const String kDefaultPhotoUrl = url;

  CollectionReference usersCollection =
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

  Future<void> createUserInFirebase({
    String? username,
    Function? onError,
    required User user,
    String? phoneNumber,
    required List<String> interests,
  }) async {
    try {
      await usersCollection.doc(user.uid).set({
        'bio': '',
        'email': user.email,
        'id': user.uid,
        'interests': interests,
        'lastSeen': null,
        'phone': phoneNumber,
        'photoUrl': kDefaultPhotoUrl,
        'status': 'Online',
        'username': username,
        'userCreated': Timestamp.now(),
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
    final currentUser = auth.currentUser!;
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
