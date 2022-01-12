import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

import 'change_displayname_viewmodel.dart';

class ChangeDisplayNameView extends StatelessWidget {
  const ChangeDisplayNameView({Key? key}) : super(key: key);

  static const String id = '/ChangeDisplayNameView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeDisplayNameViewModel>.reactive(
      viewModelBuilder: () => ChangeDisplayNameViewModel(),
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
          extendBodyBehindAppBar: true,
          appBar: cwAuthAppBar(
            context,
            title: '',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, box, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    cwEADetailsTile(context, 'Your Current Display Name'),
                    Text(box.get(FireUserField.displayName),
                              style:  TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.mediumBlack,
                              ),
                    ),
                    verticalSpaceRegular,
                    const Divider(),
                    verticalSpaceRegular,
                    cwEADescriptionTitle(context, 'Type Your New Display Name'),
                    verticalSpaceSmall,
                    cwEATextField(context, model.dispayNameTech, 'Display Name', onChanged: (value) {
                      model.updateDisplayNameEmpty();
                      if(!model.isEdited) {model.updateIsEdited(true); }
                    }),
                    verticalSpaceLarge,
                    CWAuthProceedButton( buttonTitle: 'Save', onTap: () {
                      model.updateUserProperty(context, FireUserField.displayName, model.dispayNameTech.text.trim(),);
                    }, isLoading: model.isBusy, isActive: model.isActive ),
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