import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'update_password_viewmodel.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdatePasswordViewModel>.reactive(
      viewModelBuilder: () => UpdatePasswordViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: 'Update Password',
              onPressed: () => Navigator.pop(context)),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: model.resetPasswordFormKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  verticalSpaceLarge,
                  cwEADetailsTile(context, 'Want to update password ??',
                      subtitle: 'Enter your password.'),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Type Your Current Password'),
                  cwEATextField(context, model.passwordTech, 'Password',
                      onChanged: (value) => model.updatePasswordEmpty()),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Type Your New Password'),
                  cwEATextField(context, model.newPasswordTech, 'New Password',
                      onChanged: (value) => model.updateNewPasswordEmpty()),
                  verticalSpaceLarge,
                  cwAuthProceedButton(
                    context,
                    buttonTitle: 'Update Password',
                    isActive:
                        model.passwordNotEmpty && model.newPasswordNotEmpty,
                    isLoading: model.isBusy,
                    onTap: () {
                      if (model.resetPasswordFormKey.currentState!.validate()) {
                        model
                            .updateUserPassword(
                                context, model.newPasswordTech.text)
                            .whenComplete(() {
                          model.passwordTech.clear();
                          model.newPasswordTech.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}