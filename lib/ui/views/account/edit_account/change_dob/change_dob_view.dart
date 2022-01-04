import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'change_dob_viewmodel.dart';

class ChangeDobView extends StatelessWidget {
  const ChangeDobView({Key? key}) : super(key: key);

  static const String id = '/ChangeDobView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeDobViewModel>.reactive(
      onModelReady: (model) {
        model.birthDateFormatter();
      },
      viewModelBuilder: () => ChangeDobViewModel(),
      builder: (context, model, child) => WillPopScope(
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
                      iconBackgroundColor: Colors.red);
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
            title: '',
            onPressed: () => Navigator.maybePop(context),
          ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, box, child) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  cwEADetailsTile(
                      context,
                      model.isDobNull
                          ? 'Add Your Date of Birth'
                          : 'Your Current Date of Birth'),
                  Text(
                    model.isDobNull
                        ? 'Please add your date of birth carefully. \nIt cannot be changed later.'
                        : model.formattedBirthDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.mediumBlack,
                    ),
                  ),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(
                      context,
                      model.isDobNull
                          ? 'Select Your Date of Birth'
                          : 'You have already set your date of birth. You cannot change it now. For any queries about this, write us at the support@dule.org.'),
                  verticalSpaceLarge,
                  model.isDobNull
                      ? SizedBox(
                          height:
                              screenHeightPercentage(context, percentage: 0.5),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              brightness: Theme.of(context).brightness,
                            ),
                            child: CupertinoDatePicker(
                              initialDateTime:
                                  DateTime.utc(DateTime.now().year - 7),
                              minimumYear: DateTime.now().year - 120,
                              onDateTimeChanged: (dateTime) {
                                model.updateDob(dateTime);
                                model.updateAge(dateTime);
                                if (!model.isEdited) {
                                  model.updateIsEdited(true);
                                }
                              },
                              maximumYear: DateTime.now().year - 7,
                              mode: CupertinoDatePickerMode.date,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  model.isDobNull
                      ? verticalSpaceSmall
                      : const SizedBox.shrink(),
                  model.isDobNull
                      ? CWAuthProceedButton(
                          buttonTitle: 'Save',
                          onTap: () async {
                            final shouldUpdateDob = await showDialog(
                              context: context,
                              builder: (context) {
                                return DuleAlertDialog(
                                  title:
                                      'Are you sure that you are ${model.age} ?',
                                  icon: FeatherIcons.calendar,
                                  primaryButtonText: 'Save',
                                  primaryOnPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  secondaryButtontext: 'Cancel',
                                  secondaryOnPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  secondaryButtonTextStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                );
                              },
                            );
                            shouldUpdateDob
                                ? model.updateUserProperty(
                                    context,
                                    FireUserField.dob,
                                    model.dobInMilliseconds,
                                  )
                                : () {};
                          },
                          isLoading: model.isBusy,
                          isActive: model.isEdited,
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
