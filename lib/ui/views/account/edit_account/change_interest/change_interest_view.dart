import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/constants/interest.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'change_interest_viewmodel.dart';
import 'widgets/widgets.dart';

class ChangeInterestView extends StatelessWidget {
  const ChangeInterestView({Key? key}) : super(key: key);

  static const String id = '/ChangeInterestView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeInterestViewModel>.reactive(
      viewModelBuilder: () => ChangeInterestViewModel(),
      onModelReady: (model) => model.gettingInterests(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.isEdited) {
              bool shouldPop = await showDialog(
                  context: context,
                  builder: (context) {
                    return DuleAlertDialog(
                      title: 'Delete the changes ?',
                      icon: FeatherIcons.alertOctagon,
                      primaryButtonText: 'Yes',
                      secondaryButtontext: 'No',
                      primaryOnPressed: () => Navigator.pop(context, true),
                      secondaryOnPressed: () => Navigator.pop(context, false),
                      iconBackgroundColor: Theme.of(context).colorScheme.red
                    );
                  });
              return shouldPop;
            } else {
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
            appBar: cwAuthAppBar(
              context,
              title: 'Change Interests',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      verticalSpaceRegular,
                      cwCIInterestTopicPicker(
                        context,
                        'Movies & Telvision',
                        userInterest.moviesAndTelevision,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Activities',
                        userInterest.activities,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Arts & Culture',
                        userInterest.artsAndCulture,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Automotive',
                        userInterest.automotive,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Business',
                        userInterest.business,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Career',
                        userInterest.careers,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Programming',
                        userInterest.codingLanguages,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Education',
                        userInterest.education,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Food & Drink',
                        userInterest.foodAndDrink,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Gaming',
                        userInterest.gaming,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Health & Fitness',
                        userInterest.healthAndFitness,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Life Stages',
                        userInterest.lifeStages,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Personal Finance',
                        userInterest.personalFinance,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Pets',
                        userInterest.pets,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Science',
                        userInterest.science,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Social Issues',
                        userInterest.socialIssues,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Sports',
                        userInterest.sports,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Style & Fashion',
                        userInterest.styleAndFashion,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Technology & Computing',
                        userInterest.technologyAndComputing,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Travel',
                        userInterest.travel,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: cwAuthProceedButton(context,
                      buttonTitle: 'Done',
                      isLoading: model.isBusy,
                      onTap: () => model.updateUserSelectedInterests(context),
                      isActive: model.isEdited),
                ),
                verticalSpaceLarge,
                bottomPadding(context)
              ],
            ),
          ),
        );
      },
    );
  }
}
