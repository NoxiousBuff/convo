import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/constants/app_strings.dart';

final letterService = LetterService();

class LetterService {
  final log = getLogger('LetterService');

  final CollectionReference _lettersCollection =
      FirebaseFirestore.instance.collection(lettersFirestoreKey);

  final CollectionReference _myLettersCollection = FirebaseFirestore.instance
      .collection(lettersFirestoreKey)
      .doc(hiveApi.getUserDataWithHive(FireUserField.id))
      .collection(usersLettersFirestoreKey);

  Future<void> sendLetter(String userUid, String letterText,
      {Function? onError, Function? onComplete}) async {
    _lettersCollection
        .doc(userUid)
        .collection(usersLettersFirestoreKey)
        .doc(hiveApi.getUserDataWithHive(FireUserField.id))
        .set({
      LetterFields.id: hiveApi.getUserDataWithHive(FireUserField.id),
      LetterFields.photoUrl: hiveApi.getUserDataWithHive(FireUserField.photoUrl),
      LetterFields.displayName: hiveApi.getUserDataWithHive(FireUserField.displayName),
      LetterFields.username: hiveApi.getUserDataWithHive(FireUserField.username),
      LetterFields.letterText: letterText,
      LetterFields.timestamp: Timestamp.now(),
    }).then((value) {
      log.i('letter sent successfully');
      if (onComplete != null) onComplete();
    }).catchError((e) {
      log.e('Error catched in sending the letter : $e');
      if (onError != null) onError();
    });
  }

  Stream<QuerySnapshot> getUsersLetters() {
    return _myLettersCollection
        .orderBy(LetterFields.timestamp, descending: true)
        .snapshots();
  }
}
