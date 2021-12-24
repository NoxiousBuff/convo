import 'package:hint/extensions/custom_color_scheme.dart';

import 'pick_interest_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class PickInterestsView extends StatelessWidget {
  const PickInterestsView({
    Key? key,
    required this.countryCode,
    required this.displayName,
    required this.phoneNumber,
    required this.username,
  }) : super(key: key);

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
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
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
                      context, 
                      'Most Popular',
                      userInterest.populatInterests,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Movies & Telvision',
                      userInterest.moviesAndTelevision,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Activities',
                      userInterest.activities,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Arts & Culture',
                      userInterest.artsAndCulture,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Automotive',
                      userInterest.automotive,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Business',
                      userInterest.business,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Career',
                      userInterest.careers,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Programming',
                      userInterest.codingLanguages,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Education',
                      userInterest.education,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Food & Drink',
                      userInterest.foodAndDrink,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Gaming',
                      userInterest.gaming,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Health & Fitness',
                      userInterest.healthAndFitness,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Life Stages',
                      userInterest.lifeStages,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Personal Finance',
                      userInterest.personalFinance,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Pets',
                      userInterest.pets,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Science',
                      userInterest.science,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Social Issues',
                      userInterest.socialIssues,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Sports',
                      userInterest.sports,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Style & Fashion',
                      userInterest.styleAndFashion,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Technology & Computing',
                      userInterest.technologyAndComputing,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Travel',
                      userInterest.travel,
                      model,
                      color: Theme.of(context).colorScheme.red,
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
                  model.createUserInFirebase(
                    context,
                    country: model.countryName,
                    phoneNumber: phoneNumber,
                    displayName: displayName,
                    countryPhoneCode: countryCode,
                    username: username,
                  );

                  model.userClickedButtonChanger();
                  if (model.userClickedButton > 3) {
                    model.createUserInFirebase(
                      context,
                      country: model.countryName,
                      phoneNumber: phoneNumber,
                      displayName: displayName,
                      countryPhoneCode: countryCode,
                      username: username,
                    );
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
