import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';

final letterService = LetterService();

class LetterService {
  final log = getLogger('LetterService');

  final CollectionReference _letterCollection =
      FirebaseFirestore.instance.collection(lettersFirestoreKey);

  final CollectionReference _receivedLettersCollection = FirebaseFirestore
      .instance
      .collection(lettersFirestoreKey)
      .doc(hiveApi.getUserData(FireUserField.id))
      .collection(receivedLettersFirestoreKey);

  final CollectionReference _sentLettersCollection = FirebaseFirestore.instance
      .collection(lettersFirestoreKey)
      .doc(hiveApi.getUserData(FireUserField.id))
      .collection(sentLettersFirestoreKey);

  Future<void> sendLetter(FireUser fireUser, String letterText,
      {Function? onError, Function? onComplete}) async {
    final idFrom = hiveApi.getUserData(FireUserField.id);
    final photoUrl = hiveApi.getUserData(FireUserField.photoUrl);
    final displayName = hiveApi.getUserData(FireUserField.displayName);
    final username = hiveApi.getUserData(FireUserField.username);
    final timestamp = Timestamp.now();

    _letterCollection
        .doc(fireUser.id)
        .collection(receivedLettersFirestoreKey)
        .add({
      LetterFields.idTo: fireUser.id,
      LetterFields.idFrom: idFrom,
      LetterFields.photoUrl: photoUrl,
      LetterFields.displayName: displayName,
      LetterFields.username: username,
      LetterFields.letterText: letterText,
      LetterFields.timestamp: timestamp,
    }).then((value) {
      log.i('letter sent successfully');
      if (onComplete != null) onComplete();
    }).catchError((e) {
      log.e('Error catched in sending the letter : $e');
      if (onError != null) onError();
    });
    _sentLettersCollection.add({
      LetterFields.idTo: fireUser.id,
      LetterFields.idFrom: idFrom,
      LetterFields.photoUrl: fireUser.photoUrl,
      LetterFields.displayName: fireUser.displayName,
      LetterFields.username: fireUser.username,
      LetterFields.letterText: letterText,
      LetterFields.timestamp: timestamp,
    }).then((value) {
      log.i('letter sent successfully');
      if (onComplete != null) onComplete();
    }).catchError((e) {
      log.e('Error catched in sending the letter : $e');
      if (onError != null) onError();
    });
  }

  Stream<QuerySnapshot> getReceivedLetters() {
    return _receivedLettersCollection
        .orderBy(LetterFields.timestamp, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getSentLetters() {
    return _sentLettersCollection
        .orderBy(LetterFields.timestamp, descending: true)
        .snapshots();
  }
}
