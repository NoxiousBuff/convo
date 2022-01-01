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

import 'change_bio_viewmodel.dart';

class ChangeBioView extends StatelessWidget {
  const ChangeBioView({Key? key}) : super(key: key);

  static const String id = '/ChangeBioView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeBioViewModel>.reactive(
      viewModelBuilder: () => ChangeBioViewModel(),
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
                      iconBackgroundColor: Colors.red
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
            title: '',
            onPressed: () => Navigator.maybePop(context),
          ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, box, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    cwEADetailsTile(context, 'Your Current Bio'),
                    Text(box.get(FireUserField.bio),
                              style:  TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.mediumBlack,
                              ),
                    ),
                    verticalSpaceRegular,
                    const Divider(),
                    verticalSpaceRegular,
                    cwEADescriptionTitle(context, 'Type Your New Bio Name'),
                    verticalSpaceSmall,
                    cwEATextField(context, model.bioNameTech, 'Bio', onChanged: (value) {
                      model.updateBioNameEmpty();
                      if(!model.isEdited) {
                        model.updateIsEdited(true);
                      }
                    }, maxLength: 250, expands: true),
                    verticalSpaceLarge,
                    CWAuthProceedButton( buttonTitle: 'Save', onTap: () {
                      model.updateUserProperty(context, FireUserField.bio, model.bioNameTech.text.trim(),);
                    }, isLoading: model.isBusy, isActive: model.isActive),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}