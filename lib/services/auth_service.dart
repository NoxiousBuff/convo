import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';

final authService = AuthService();

class AuthService {
  

  final log = getLogger('AuthService');

  final firestoreApi = locator<FirestoreApi>();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';


  static User? liveUser = FirebaseAuth.instance.currentUser;

  signUp({
    required String email,
    required String password,
    required Function onComplete,
    Function? accountExists,
    Function? weakPassword,
    Function? randomError,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await value.user!.sendEmailVerification();
        onComplete();
        return value;
      });
      log.i('User has been created in the firebase authentication.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log.e(e.message);
        if (weakPassword != null) weakPassword();
      } else if (e.code == 'email-already-in-use') {
        log.e(e.message);
        if (accountExists != null) accountExists();
      } else {
        log.e(e.message);
        if (randomError != null) randomError();
      }
    } catch (e) {
      log.e('Error from try catch : $e');
    }
  }

  logIn({
    required String email,
    required String password,
    required Function onComplete,
    Function? noAccountExists,
    Function? invalidEmail,
    Function? wrongPassword,
    Function? onError,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        log.i('The User with email : $email has been successfully logged In');
        FireUser? fireuser =
            await firestoreApi.getUserFromFirebase(value.user!.uid);
        if (fireuser != null) {
          await firestoreApi.saveUserDataInHive(
              FireUserField.bio, fireuser.bio);
          await firestoreApi.saveUserDataInHive(
              FireUserField.country, fireuser.country);
          await firestoreApi.saveUserDataInHive(
              FireUserField.countryPhoneCode, fireuser.countryPhoneCode);
          await firestoreApi.saveUserDataInHive(
              FireUserField.email, fireuser.email);
          await firestoreApi.saveUserDataInHive(
              FireUserField.hashTags, fireuser.hashTags);
          await firestoreApi.saveUserDataInHive(FireUserField.id, fireuser.id);
          await firestoreApi.saveUserDataInHive(
              FireUserField.interests, fireuser.interests);
          await firestoreApi.saveUserDataInHive(
              FireUserField.phone, fireuser.phone);
          await firestoreApi.saveUserDataInHive(
            FireUserField.photoUrl,
            fireuser.photoUrl,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.displayName,
            fireuser.displayName,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.userCreated,
            fireuser.userCreated.millisecondsSinceEpoch,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.username,
            fireuser.username,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.blocked,
            fireuser.blocked,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.blockedBy,
            fireuser.blockedBy,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.romanticStatus,
            fireuser.romanticStatus,
          );
          await firestoreApi.saveUserDataInHive(
            FireUserField.gender,
            fireuser.gender,
          );
          await firestoreApi.saveUserDataInHive(
              FireUserField.dob, fireuser.dob);
        }
        onComplete();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log.e(e.message);
        if (noAccountExists != null) noAccountExists();
      } else if (e.code == 'invalid-email') {
        log.e(e.message);
        if (invalidEmail != null) invalidEmail();
      } else if (e.code == 'wrong-password') {
        log.e(e.message);
        if (wrongPassword != null) wrongPassword();
      } else {
        log.e(e.message);
        if (onError != null) onError();
      }
    }
  }

  signOut(BuildContext context, {Function? onSignOut}) async {
    await _auth.signOut();
    log.i('The user has been signed out successfully.');
    if (onSignOut != null) {
      onSignOut();
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, WelcomeView.id, (route) => false);
    }
  }

  Future<void> forgotPassword(String email,
      {Function? onComplete,
      Function? noAccountExists,
      Function? invalidEmailAddress,
      Function? onError}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        if (onComplete != null) onComplete();
        log.i(
            'The user with email : $email has been successfully sent a password reset email.');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        log.e(e.message);
        if (invalidEmailAddress != null) invalidEmailAddress();
      } else if (e.code == 'auth/user-not-found') {
        log.e(e.message);
        if (noAccountExists != null) noAccountExists();
      } else {
        if (onError != null) onError();
      }
    }
  }

  Future<void> changeUserDisplayName(String value, {Function? onError}) async {
    getLogger('AuthService').i('Initiating Changing User Display Name');
    await _auth.currentUser!.updateDisplayName(value).then((e) {
      getLogger('Auth Service')
          .i('User Display Name is successfully changed to : $value');
    }).catchError((err) {
      if (onError != null) onError();
      getLogger('Auth Service')
          .w('Error occurred in changing display name. Error : $err');
    });
  }

  Future<void> changeUserEmail(String value, {Function? onError}) async {
    try {
      getLogger('AuthService').i('Initiating Changing User Display Name');
    await _auth.currentUser!.updateEmail(value).then((e) {
      getLogger('Auth Service')
          .i('User Display Name is successfully changed to : $value');
    });
    } on FirebaseAuthException catch (e) {
       if (onError != null) onError();
      getLogger('Auth Service')
          .w('Error occurred in changing display name. Error : ${e.message}');
    }

     

  }
}
