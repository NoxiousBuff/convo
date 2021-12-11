import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/services/letter_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ReceivedLettersViewModel extends StreamViewModel<QuerySnapshot> {
  final log = getLogger('ReceivedLettersViewModel');

  @override
  Stream<QuerySnapshot> get stream => letterService.getReceivedLetters();
}