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
                      Interest.popularInterests,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Movies & Telvision',
                      Interest.moviesAndTelevision,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Activities',
                      Interest.activities,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Arts & Culture',
                      Interest.artsAndCulture,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Automotive',
                      Interest.automotive,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Business',
                      Interest.business,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Career',
                      Interest.careers,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Programming',
                      Interest.codingLanguages,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Education',
                      Interest.education,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Food & Drink',
                      Interest.foodAndDrink,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Gaming',
                      Interest.gaming,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Health & Fitness',
                      Interest.healthAndFitness,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Life Stages',
                      Interest.lifeStages,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Personal Finance',
                      Interest.personalFinance,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Pets',
                      Interest.pets,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Science',
                      Interest.science,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Social Issues',
                      Interest.socialIssues,
                      model,
                      color: Theme.of(context).colorScheme.yellow,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Sports',
                      Interest.sports,
                      model,
                      color: Theme.of(context).colorScheme.green,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Style & Fashion',
                      Interest.styleAndFashion,
                      model,
                      color: Theme.of(context).colorScheme.blue,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Technology & Computing',
                      Interest.technologyAndComputing,
                      model,
                      color: Theme.of(context).colorScheme.purple,
                    ),
                    cwAuthInterestTopicPicker(
                      context, 
                      'Travel',
                      Interest.travel,
                      model,
                      color: Theme.of(context).colorScheme.red,
                    ),
                  ],
                ),
              ),
              CWAuthProceedButton(
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
