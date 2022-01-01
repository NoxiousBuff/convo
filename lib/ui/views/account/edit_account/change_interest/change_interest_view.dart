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
                        Interest.moviesAndTelevision,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Activities',
                        Interest.activities,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Arts & Culture',
                        Interest.artsAndCulture,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Automotive',
                        Interest.automotive,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Business',
                        Interest.business,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Career',
                        Interest.careers,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Programming',
                        Interest.codingLanguages,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Education',
                        Interest.education,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Food & Drink',
                        Interest.foodAndDrink,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Gaming',
                        Interest.gaming,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Health & Fitness',
                        Interest.healthAndFitness,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Life Stages',
                        Interest.lifeStages,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Personal Finance',
                        Interest.personalFinance,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Pets',
                        Interest.pets,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Science',
                        Interest.science,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Social Issues',
                        Interest.socialIssues,
                        model,
                        color: Theme.of(context).colorScheme.yellow,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Sports',
                        Interest.sports,
                        model,
                        color: Theme.of(context).colorScheme.green,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Style & Fashion',
                        Interest.styleAndFashion,
                        model,
                        color: Theme.of(context).colorScheme.blue,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Technology & Computing',
                        Interest.technologyAndComputing,
                        model,
                        color: Theme.of(context).colorScheme.purple,
                      ),
                      cwCIInterestTopicPicker(
                        context,
                        'Travel',
                        Interest.travel,
                        model,
                        color: Theme.of(context).colorScheme.red,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CWAuthProceedButton(
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
