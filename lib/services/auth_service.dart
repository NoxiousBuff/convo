import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/pods/genral_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/constants/message_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';

String verificationCode = '';

final authService = AuthService();

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String kDefaultPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  final log = getLogger('AuthService');

  static User? liveUser = FirebaseAuth.instance.currentUser;

  // signUp(
  //     {required String email,
  //     required String password,
  //     required Function onComplete,
  //     Function? accountExists,
  //     Function? weakPassword,
  //     Function? randomError}) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     log.i('User has been created in the firebase authentication.');
  //     await userCredential.user!
  //         .updatePhotoURL(kDefaultPhotoUrl)
  //         .catchError((e) => getLogger('AuthService').e(e));
  //     await _firestoreApi
  //         .createUserInFirebase(
  //             user: userCredential.user!, interests: [], onError: randomError)
  //         .then((value) => onComplete);
  //     await userCredential.user!.sendEmailVerification();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       getLogger('FirebaseAuthException from SignUp')
  //           .w('The password provided is too weak.');
  //       if (weakPassword != null) weakPassword();
  //     } else if (e.code == 'email-already-in-use') {
  //       getLogger('FirebaseAuthException')
  //           .w('The account already exists for that email.');
  //       if (accountExists != null) accountExists();
  //     } else {
  //       getLogger('FirebaseAuthException').w(
  //           'Some error prevented the registration. Please try again later.');
  //       if (randomError != null) randomError();
  //     }
  //   } catch (e) {
  //     getLogger('AuthService').e(e);
  //   }
  // }

  logIn({
    required String email,
    required String password,
    required Function onComplete,
    Function? noAccountExists,
    Function? onError,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        log.i('The User with email : $email has been successfully logged In');
        onComplete();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getLogger('FirebaseAuthException from LogIn')
            .w('No user found for that email.');
        if (noAccountExists != null) noAccountExists();
      } else {
        getLogger('FirebaseAuthException from LogIn')
            .w('Incorrect UserName and Password.');
        if (onError != null) onError();
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    await firestoreApi.updateUser(
      uid: FirestoreApi.liveUserUid,
      property: UserField.status,
      updateProperty: 'Offline',
    );
    await _auth.signOut().catchError((e) {
      log.e('Firestore Signout:$e');
    });

    log.i('The user has been signed out successfully.');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailRegisterView(),
      ),
    );
  }

  Future<void> forgotPassword(String email,
      {Function? onComplete, Function? onError}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      if (onComplete != null) onComplete();
      log.i(
          'The user with email : $email has been successfully sent a password reset email.');
    }).onError((error, stackTrace) {
      if (onError != null) onError();
      log.w(
          'There has been an error sending reset password email to user with email : $email');
    });
  }

  Future<void> changeUserDisplayName(String value, {Function? onError}) async {
    getLogger('AuthService').i('Initiating Changing User Display Name');
    await _auth.currentUser!.updateDisplayName(value).then((e) {
      log.i('User Display Name is successfully changed to : $value');
    }).catchError((err) {
      if (onError != null) onError();
      getLogger('Auth Service')
          .w('Error occurred in changing display name. Error : $err');
    });
  }

  Future<void> signUpWithPhone(String phoneNumber, BuildContext context) async {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        final pod = context.read(codeProvider);
        final localSmsCode = credential.smsCode;
        if (localSmsCode != null) pod.getCode(localSmsCode);
        log.wtf('credential.smsCode : $localSmsCode');
        log.wtf('Verification Completed Successfuly.');
        log.wtf('Phone Auth Credential: ${pod.phoneAuthCredential}');
        pod.getPhoneCredentials(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e('The provided phone number is not valid.');
        } else {
          log.e('This was the error in creating phone auth credential : $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: resendToken.toString());
        log.v('Phone Auth Credential: $credential');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }
}
