import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

import 'package:hint/ui/views/settings/update_email/update_email_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

class UpdateEmailView extends StatelessWidget {
  const UpdateEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateEmailViewModel>.reactive(
      viewModelBuilder: () => UpdateEmailViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: 'Update Email', onPressed: () => Navigator.pop(context)),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, userDataHiveBox, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: model.updateEmailFormKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      cwEADetailsTile(context, 'Your Current Email'),
                      Text(
                        userDataHiveBox.get(FireUserField.email),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                      ),
                      verticalSpaceRegular,
                      const Divider(),
                      verticalSpaceRegular,
                      cwEADescriptionTitle(context, 'Type Your New Email'),
                      verticalSpaceSmall,
                      cwEATextField(context, model.upadteEmailTech, 'New Email',
                          onChanged: (value) => model.updateDisplayNameEmpty(),
                          validator: (value) {
                            if (!isEmail(value!)) {
                              return customSnackbars.errorSnackbar(context,
                                  title: 'Provide a valid email address');
                            }
                          }),
                      verticalSpaceSmall,
                      cwEADescriptionTitle(context, 'Type Your Password'),
                      cwEATextField(context, model.passwordTech, 'Password',
                          onChanged: (val) => model.updatePasswordEmpty()),
                      verticalSpaceLarge,
                      cwAuthProceedButton(context,
                          buttonTitle: 'Change Email',
                          isActive: !model.isDisplayNameEmpty &&
                              !model.isPasswordEmpty,
                          isLoading: model.isBusy, onTap: () {
                        if (model.updateEmailFormKey.currentState!.validate()) {
                          model
                              .updateUserEmail(
                                  context,
                                  model.upadteEmailTech.text,
                                  model.passwordTech.text)
                              .whenComplete(() {
                            model.upadteEmailTech.clear();
                            model.passwordTech.clear();
                          });
                        }
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}