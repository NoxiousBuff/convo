import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/interest.dart';
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
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: cwAuthAppBar(
            context,
            title: 'Change Interests',
            onPressed: () => Navigator.pop(context),
            actions: [
              model.isBusy
                  ? const Center(
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.blue,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : InkWell(
                      child: const Icon(
                        FeatherIcons.check,
                        color: AppColors.blue,
                      ),
                      onTap: () {
                        model.saveData(context);
                      },
                    ),
              horizontalSpaceMedium,
            ],
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 80),
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
        );
      },
    );
  }
}
