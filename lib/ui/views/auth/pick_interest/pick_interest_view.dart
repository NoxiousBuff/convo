import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'pick_interest_viewmodel.dart';

class PickInterestsView extends StatelessWidget {
  const PickInterestsView(
      {Key? key,
      required this.countryCode,
      required this.displayName,
      required this.phoneNumber})
      : super(key: key);

  static const String id = '/PickInterestsView';

  final String displayName;
  final String countryCode;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickInterestsViewModel>.reactive(
      viewModelBuilder: () => PickInterestsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: cwAuthAppBar(context, title: 'Pick few things you like'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceRegular,
                  cwAuthHeadingTitle(context,
                      title: 'What\'re your \nhobbies..?'),
                  verticalSpaceSmall,
                  cwAuthDescription(context,
                      title: 'Choose at least ten interests'),
                  verticalSpaceSmall,
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 200),
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
                  bottomPadding(context)
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    cwAuthProceedButton(
                      context,
                      buttonTitle: 'Done',
                      isLoading: model.isBusy,
                      isActive: model.hasUserPickedTenInterests,
                      onTap: () async {
                        model.createUserInFirebase(context,
                            displayName: displayName,
                            phoneNumber: phoneNumber,
                            countryPhoneCode: countryCode);
                      },
                    ),
                    verticalSpaceLarge,
                    bottomPadding(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
