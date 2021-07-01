import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/helper/shared_pref_helper.dart';
import 'package:hint/views/register/email_register_view.dart';

class AuthMethods {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  signUp({
    required String userName,
    required String email,
    required String password,
    required Function onComplete,
    Function? accountExists,
    Function? weakPassword,
    Function? randomError
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!
          .updateProfile(displayName: userName, photoURL: kDefaultPhotoUrl)
          .catchError((e) => print(e));
      await createUserInFirebase(
          user: userCredential.user!, userName: userName, onError: randomError);
      await userCredential.user!.sendEmailVerification();
      SharedPreferenceHelper().saveUserEmail(userCredential.user!.email!);
      SharedPreferenceHelper().saveUserName(userName);
      SharedPreferenceHelper().saveUserId(userCredential.user!.uid);
      SharedPreferenceHelper().saveUserPhoto(kDefaultPhotoUrl);
      onComplete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        weakPassword!();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        accountExists!();
      } else {
        print('Some error prevented the registration. Please try again later.');
        randomError!();
      }
    } catch (e) {
      print(e);
    }
  }

  createUserInFirebase(
      {required User user, String? userName, Function? onError}) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'username': userName,
        'photoUrl': kDefaultPhotoUrl,
        'email': user.email,
        'bio': '',
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      onError!();
    }
  }

  logIn({
    required String email,
    required String password,
    required Function onComplete,
    Function? noAccountExists,
    Function? onError,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferenceHelper().saveUserEmail(userCredential.user!.email!);
      SharedPreferenceHelper().saveUserName(userCredential.user!.displayName!);
      SharedPreferenceHelper().saveUserId(userCredential.user!.uid);
      SharedPreferenceHelper().saveUserPhoto(kDefaultPhotoUrl);
      onComplete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        noAccountExists!();
      } else {
        print('Incorrect UserName and Password.');
        onError!();
      }
    }
  }

  signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailRegisterView()));
  }
}
