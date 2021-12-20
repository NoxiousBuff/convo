import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/letter_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ReadLetterViewModel extends BaseViewModel {
  final log = getLogger('ReadLetterViewModel');

  final LetterModel letter;

  ReadLetterViewModel(this.letter);

  String get formaattedDate => Jiffy(letter.timestamp.toDate()).format('MMM do, yyyy');

  bool get isSentByMe => letter.id == hiveApi.getUserData(FireUserField.id);

}