import 'package:flutter/material.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class ChangeInterestViewModel extends BaseViewModel {
  final log = getLogger('ChangeInterestViewModel');

  bool isSelected = false;
  List<dynamic> _userSelectedInterests = [];
  List<dynamic> get userSelectedInterests => _userSelectedInterests;

  final List<String> _interestNames = const [
    'Movies & Telvision',
    'Activities',
    'Arts & Culture',
    'Automotive',
    'Business',
    'Career',
    'Programming',
    'Education',
    'Food & Drink',
    'Gaming',
    'Health & Fitness',
    'Life Stages',
    'Personal Finance',
    'Pets',
    'Science',
    'Social Issues',
    'Sports',
    'Style & Fashion',
    'Technology & Computing',
    'Travel',
  ];

  final List<List<String>> _allInterestLists = [
    userInterest.moviesAndTelevision,
    userInterest.activities,
    userInterest.artsAndCulture,
    userInterest.automotive,
    userInterest.business,
    userInterest.careers,
    userInterest.codingLanguages,
    userInterest.education,
    userInterest.foodAndDrink,
    userInterest.gaming,
    userInterest.healthAndFitness,
    userInterest.lifeStages,
    userInterest.personalFinance,
    userInterest.pets,
    userInterest.science,
    userInterest.socialIssues,
    userInterest.sports,
    userInterest.styleAndFashion,
    userInterest.technologyAndComputing,
    userInterest.travel
  ];

  final List<Color> _colorListForInterest = [
    AppColors.yellow,
    AppColors.green,
    AppColors.blue,
    AppColors.purple,
    AppColors.red,
    AppColors.yellow,
    AppColors.green,
    AppColors.blue,
    AppColors.purple,
    AppColors.red,
    AppColors.yellow,
    AppColors.green,
    AppColors.blue,
    AppColors.purple,
    AppColors.red,
    AppColors.yellow,
    AppColors.green,
    AppColors.blue,
    AppColors.purple,
    AppColors.red,
  ];

  List<List<String>> get allInterestList => _allInterestLists;

  List<Color> get colorListForInterest => _colorListForInterest;

  List<String> get interestNames => _interestNames;

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  void updateIsEdited(bool localIsEdited) {
    _isEdited = localIsEdited;
    notifyListeners();
  } 

  void gettingInterests() {
    _userSelectedInterests =
        Hive.box(HiveApi.userDataHiveBox).get(FireUserField.interests);
    notifyListeners();
    log.wtf('UserSelectedinterests:$_userSelectedInterests');
  }
final firestoreApi = locator<FirestoreApi>();
  Future<void> updateUserSelectedInterests(BuildContext context) async {
    setBusy(true);
    await firestoreApi
        .updateUser(
      uid: AuthService.liveUser!.uid,
      value: _userSelectedInterests,
      propertyName: FireUserField.interests,
    )
        .then((value) {
      hiveApi.updateUserData(
          FireUserField.interests, _userSelectedInterests);
      customSnackbars.successSnackbar(context,
          title: 'You Data Was Sucessfully Saved');
    });
    setBusy(false);
    Navigator.pop(context);
  }
}
