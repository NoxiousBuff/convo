import 'pick_interest_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class PickInterestsView extends StatelessWidget {
  const PickInterestsView(
      {Key? key,
      required this.countryCode,
      required this.displayName,
      required this.phoneNumber,
      required this.username,
      })
      : super(key: key);

  static const String id = '/PickInterestsView';

  final String displayName;
  final String countryCode;
  final String phoneNumber;
  final String username;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickInterestsViewModel>.reactive(
      viewModelBuilder: () => PickInterestsViewModel(),
      onModelReady: (model) {
        model.lookUpGeopoint(context);
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: LightAppColors.background,
        appBar: cwAuthAppBar(context, title: 'Pick few things you like'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceRegular,
              cwAuthHeadingTitle(context, title: 'What\'re your \nhobbies..?'),
              verticalSpaceSmall,
              cwAuthDescription(context,
                  title: 'Choose at least ten interests'),
              verticalSpaceSmall,
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    cwAuthInterestTopicPicker(
                      'Most Popular',
                      userInterest.populatInterests,
                      model,
                      color: AppColors.red,
                    ),
                    cwAuthInterestTopicPicker(
                      'Movies & Telvision',
                      userInterest.moviesAndTelevision,
                      model,
                      color: AppColors.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      'Activities',
                      userInterest.activities,
                      model,
                      color: AppColors.green,
                    ),
                    cwAuthInterestTopicPicker(
                      'Arts & Culture',
                      userInterest.artsAndCulture,
                      model,
                      color: AppColors.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      'Automotive',
                      userInterest.automotive,
                      model,
                      color: AppColors.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      'Business',
                      userInterest.business,
                      model,
                      color: AppColors.red,
                    ),
                    cwAuthInterestTopicPicker(
                      'Career',
                      userInterest.careers,
                      model,
                      color: AppColors.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      'Programming',
                      userInterest.codingLanguages,
                      model,
                      color: AppColors.green,
                    ),
                    cwAuthInterestTopicPicker(
                      'Education',
                      userInterest.education,
                      model,
                      color: AppColors.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      'Food & Drink',
                      userInterest.foodAndDrink,
                      model,
                      color: AppColors.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      'Gaming',
                      userInterest.gaming,
                      model,
                      color: AppColors.red,
                    ),
                    cwAuthInterestTopicPicker(
                      'Health & Fitness',
                      userInterest.healthAndFitness,
                      model,
                      color: AppColors.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      'Life Stages',
                      userInterest.lifeStages,
                      model,
                      color: AppColors.green,
                    ),
                    cwAuthInterestTopicPicker(
                      'Personal Finance',
                      userInterest.personalFinance,
                      model,
                      color: AppColors.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      'Pets',
                      userInterest.pets,
                      model,
                      color: AppColors.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      'Science',
                      userInterest.science,
                      model,
                      color: AppColors.red,
                    ),
                    cwAuthInterestTopicPicker(
                      'Social Issues',
                      userInterest.socialIssues,
                      model,
                      color: AppColors.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      'Sports',
                      userInterest.sports,
                      model,
                      color: AppColors.green,
                    ),
                    cwAuthInterestTopicPicker(
                      'Style & Fashion',
                      userInterest.styleAndFashion,
                      model,
                      color: AppColors.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      'Technology & Computing',
                      userInterest.technologyAndComputing,
                      model,
                      color: AppColors.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      'Travel',
                      userInterest.travel,
                      model,
                      color: AppColors.red,
                    ),
                  ],
                ),
              ),
              cwAuthProceedButton(
                context,
                buttonTitle: 'Done',
                isLoading: model.isBusy,
                isActive: model.hasUserPickedTenInterests,
                onTap: () async {
                  final localGeoPoint = model.geoPoint;
                  if(localGeoPoint == null) {
                    await model.lookUpGeopoint(context);
                  }
                  if(localGeoPoint != null) {
                    model.createUserInFirebase(context,
                      location: localGeoPoint,
                      country: model.countryName,
                      phoneNumber: phoneNumber,
                      displayName: displayName,
                      countryPhoneCode: countryCode,
                      username: username,
                      );
                  }
                  model.userClickedButtonChanger();
                  if(model.userClickedButton > 3) {
                    //TODO: when ip registery is not working
                  }
                },
              ),
              verticalSpaceLarge,
              bottomPadding(context)
            ],
          ),
        ),
      ),
    );
  }
}
