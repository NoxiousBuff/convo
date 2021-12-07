import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'change_username_viewmodel.dart';

class ChangeUserNameView extends StatelessWidget {
  const ChangeUserNameView({Key? key}) : super(key: key);

  static const String id = '/ChangeUserNameView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeUserNameViewModel>.reactive(
      viewModelBuilder: () => ChangeUserNameViewModel(),
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
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: cwAuthAppBar(
            context,
            title: '',
            onPressed: () => Navigator.maybePop(context),
          ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
            builder: (context, box, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    cwEADetailsTile(context, 'Your Current UserName'),
                    Text(
                      box.get(FireUserField.username),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    verticalSpaceRegular,
                    const Divider(),
                    verticalSpaceRegular,
                    cwEADescriptionTitle(context, 'Type Your New UserName'),
                    verticalSpaceSmall,
                    cwEATextField(context, model.userNameTech, 'UserName',
                        onChanged: (value) {
                      model.updateUserNameEmpty();
                      if(!model.isEdited) {
                        model.updateIsEdited(true);
                      }
                    }),
                    verticalSpaceLarge,
                    cwAuthProceedButton(context, buttonTitle: 'Save',
                        onTap: () {
                      model.updateUserProperty(
                        context,
                        FireUserField.username,
                        model.userNameTech.text.trim(),
                      );
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
