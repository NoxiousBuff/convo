import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
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
                      iconBackgroundColor: Colors.red
                    );
                  });
              return shouldPop;
            } else {
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
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
                        'Movies & Telvision',
                        userInterest.moviesAndTelevision,
                        model,
                        color: AppColors.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        'Activities',
                        userInterest.activities,
                        model,
                        color: AppColors.green,
                      ),
                      cwCIInterestTopicPicker(
                        'Arts & Culture',
                        userInterest.artsAndCulture,
                        model,
                        color: AppColors.blue,
                      ),
                      cwCIInterestTopicPicker(
                        'Automotive',
                        userInterest.automotive,
                        model,
                        color: AppColors.purple,
                      ),
                      cwCIInterestTopicPicker(
                        'Business',
                        userInterest.business,
                        model,
                        color: AppColors.red,
                      ),
                      cwCIInterestTopicPicker(
                        'Career',
                        userInterest.careers,
                        model,
                        color: AppColors.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        'Programming',
                        userInterest.codingLanguages,
                        model,
                        color: AppColors.green,
                      ),
                      cwCIInterestTopicPicker(
                        'Education',
                        userInterest.education,
                        model,
                        color: AppColors.blue,
                      ),
                      cwCIInterestTopicPicker(
                        'Food & Drink',
                        userInterest.foodAndDrink,
                        model,
                        color: AppColors.purple,
                      ),
                      cwCIInterestTopicPicker(
                        'Gaming',
                        userInterest.gaming,
                        model,
                        color: AppColors.red,
                      ),
                      cwCIInterestTopicPicker(
                        'Health & Fitness',
                        userInterest.healthAndFitness,
                        model,
                        color: AppColors.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        'Life Stages',
                        userInterest.lifeStages,
                        model,
                        color: AppColors.green,
                      ),
                      cwCIInterestTopicPicker(
                        'Personal Finance',
                        userInterest.personalFinance,
                        model,
                        color: AppColors.blue,
                      ),
                      cwCIInterestTopicPicker(
                        'Pets',
                        userInterest.pets,
                        model,
                        color: AppColors.purple,
                      ),
                      cwCIInterestTopicPicker(
                        'Science',
                        userInterest.science,
                        model,
                        color: AppColors.red,
                      ),
                      cwCIInterestTopicPicker(
                        'Social Issues',
                        userInterest.socialIssues,
                        model,
                        color: AppColors.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        'Sports',
                        userInterest.sports,
                        model,
                        color: AppColors.green,
                      ),
                      cwCIInterestTopicPicker(
                        'Style & Fashion',
                        userInterest.styleAndFashion,
                        model,
                        color: AppColors.blue,
                      ),
                      cwCIInterestTopicPicker(
                        'Technology & Computing',
                        userInterest.technologyAndComputing,
                        model,
                        color: AppColors.purple,
                      ),
                      cwCIInterestTopicPicker(
                        'Travel',
                        userInterest.travel,
                        model,
                        color: AppColors.red,
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
