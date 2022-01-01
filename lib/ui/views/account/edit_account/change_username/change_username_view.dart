import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/custom_chips.dart';
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
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          extendBodyBehindAppBar: true,
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
                    cwEADetailsTile(context, 'Your Current UserName'),
                    Text(
                      box.get(FireUserField.username),
                      style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                    verticalSpaceRegular,
                    const Divider(),
                    verticalSpaceRegular,
                    cwEADescriptionTitle(context, 'Type Your New UserName'),
                    verticalSpaceSmall,
                    cwEATextField(
                      context,
                      model.userNameTech,
                      'UserName',
                      onChanged: (value) {
                        model.updateUserNameEmpty();
                        model.findUsernameExistOrNot(value);
                        if (!model.isEdited) {
                          model.updateIsEdited(true);
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[a-z0-9_\.]'),
                            allow: true, replacementString: ''),
                      ],
                    ),
                    verticalSpaceRegular,
                    Row(
                      children: [
                        Builder(
                          builder: (context) {
                            Widget child;
                            switch (model.doesExists) {
                              case UserNameExists.tooShort:
                                child = model.userNameTech.text.length < 4
                                    ? customChips.errorChip(context, 'Username too short.')
                                    : const Text('');
                                break;
                              case UserNameExists.yes:
                                child = model.userNameTech.text.length > 3
                                    ? customChips.successChip(context, 'Username exists')
                                    : const Text('');
                                break;
                              case UserNameExists.no:
                                child = model.userNameTech.text.length > 3
                                    ? customChips
                                        .errorChip(context, 'Username does not exists')
                                    : const Text('');
                                break;
                              case UserNameExists.checking:
                                child = model.userNameTech.text.length > 3
                                    ? customChips.progressChip(context)
                                    : const Text('');
                                break;
                              default:
                                {
                                  child = const Text('');
                                }
                            }
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: child,
                            );
                          },
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                    CWAuthProceedButton( buttonTitle: 'Save',
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
