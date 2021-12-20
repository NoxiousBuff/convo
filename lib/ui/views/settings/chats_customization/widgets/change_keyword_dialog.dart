import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangeKeywordDialog extends StatefulWidget {
  const ChangeKeywordDialog({Key? key, required this.animationType})
      : super(key: key);

  final String animationType;

  @override
  State<ChangeKeywordDialog> createState() => _ChangeKeywordDialogState();
}

class _ChangeKeywordDialogState extends State<ChangeKeywordDialog> {
  final TextEditingController changeKeywordTech = TextEditingController();

  bool isEmpty = true;

  void updateIsEmpty() {
    setState(() {
      isEmpty = changeKeywordTech.text.isEmpty;
    });
  }

  Widget animationDetailsTile(BuildContext context) {
    switch (widget.animationType) {
      case AnimationType.confetti:
        {
          return cwEADetailsTile(
              context, 'Current Keyword for Confetti Animation');
        }
      case AnimationType.balloons:
        {
          return cwEADetailsTile(
            context,
            'Current Keyword for Balloon Animation',
          );
        }
      default:
        {
          return cwEADetailsTile(
              context, 'Current Keyword for Confetti Animation');
        }
    }
  }

  Widget animationDescriptionTile(BuildContext context) {
    switch (widget.animationType) {
      case AnimationType.confetti:
        {
          return cwEADescriptionTitle(
              context, 'Type New Keyword For Confetti Animation');
        }
      case AnimationType.balloons:
        {
          return cwEADescriptionTitle(
              context, 'Type New Keyword For Balloons Animation');
        }
      default:
        {
          return cwEADescriptionTitle(
              context, 'Type New Keyword For Confetti Animation');
        }
    }
  }

  void animationProceedFunction() {
    switch (widget.animationType) {
      case AnimationType.confetti:
        {
          hiveApi.saveAndReplace(HiveApi.appSettingsBoxName,
              AppSettingKeys.confettiAnimation, changeKeywordTech.text.trim());
        }
        break;
      case AnimationType.balloons:
        {
          hiveApi.saveAndReplace(HiveApi.appSettingsBoxName,
              AppSettingKeys.balloonsAnimation, changeKeywordTech.text.trim());
        }
        break;
      default:
        {}
        break;
    }
  }

  Widget animationTextField(BuildContext context, Box localHiveBox) {
    switch (widget.animationType) {
      case AnimationType.confetti:
        {
          return cwEATextField(
              context,
              changeKeywordTech,
              localHiveBox.get(AppSettingKeys.confettiAnimation,
                  defaultValue: 'Congo'), onChanged: (value) {
            updateIsEmpty();
          }, maxLength: 30);
        }
      case AnimationType.balloons:
        {
          return cwEATextField(
              context,
              changeKeywordTech,
              localHiveBox.get(AppSettingKeys.balloonsAnimation,
                  defaultValue: 'Balloons'), onChanged: (value) {
            updateIsEmpty();
          }, maxLength: 30);
        }
      default:
        {
          return cwEATextField(
              context,
              changeKeywordTech,
              localHiveBox.get(AppSettingKeys.confettiAnimation,
                  defaultValue: 'Congo'), onChanged: (value) {
            updateIsEmpty();
          }, maxLength: 30);
        }
    }
  }

  Widget animationKeywordValue(BuildContext context, Box localHiveBox) {
    switch (widget.animationType) {
      case AnimationType.confetti:
        {
          return Text(
            localHiveBox.get(AppSettingKeys.confettiAnimation,
                defaultValue: 'Congo'),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color:AppColors.mediumBlack,
            ),
          );
        }
      case AnimationType.balloons:
        {
          return Text(
            localHiveBox.get(AppSettingKeys.balloonsAnimation,
                defaultValue: 'Balloons'),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color:AppColors.mediumBlack,
            ),
          );
        }
      default:
        {
          return Text(
            localHiveBox.get(AppSettingKeys.confettiAnimation,
                defaultValue: 'Congo'),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color:AppColors.mediumBlack,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
      builder: (context, appSettingsBox, child) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: '', onPressed: () => Navigator.pop(context)),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              verticalSpaceLarge,
              animationDetailsTile(context),
              animationKeywordValue(context, appSettingsBox),
              verticalSpaceRegular,
              const Divider(),
              verticalSpaceRegular,
              animationDescriptionTile(context),
              verticalSpaceSmall,
              animationTextField(context, appSettingsBox),
              verticalSpaceLarge,
              cwAuthProceedButton(
                context,
                buttonTitle: 'Save',
                onTap: () {
                  animationProceedFunction();
                  changeKeywordTech.clear();
                  Navigator.pop(context);
                },
                isActive: !isEmpty,
              ),
              verticalSpaceLarge,
              bottomPadding(context),
            ],
          ),
        );
      },
    );
  }
}