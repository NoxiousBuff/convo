import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');

  final firestoreApi = locator<FirestoreApi>();

  bool get ifCurrentUserExists => FirebaseAuth.instance.currentUser != null; 

  bool get hasCompletedAuthentication => hiveApi.getFromHive(HiveApi.appSettingsBoxName, AppSettingKeys.hasCompletedAuthentication, defaultValue: false);

  bool _shouldShowUsernameview = false;
  bool get shouldShowUsernameview => _shouldShowUsernameview;

  void getCurrentUserDocument() async {
    if(ifCurrentUserExists) {
      FireUser? currentFireUser = await firestoreApi.getUserFromFirebase(AuthService.liveUser!.uid);
      if(currentFireUser != null) {
        String username = currentFireUser.username;
        String displayName = currentFireUser.displayName;
        List<dynamic> interests = currentFireUser.interests; 
        final bool isUsernameEmpty = username == '';
        final bool isDisplayNameEmpty = displayName == '';
        final bool isInterestsListEmpty = interests.isEmpty;
        if ( isUsernameEmpty || isDisplayNameEmpty || isInterestsListEmpty) {
          _shouldShowUsernameview = true;
          notifyListeners();
        }
      } else {

      }
    } else {
      log.e('Current User don\'t exist. Did not run the get document function.');
    }
  }

}