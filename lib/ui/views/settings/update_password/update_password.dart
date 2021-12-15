import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

import 'update_password_viewmodel.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdatePasswordViewModel>.reactive(
      viewModelBuilder: () => UpdatePasswordViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: cwAuthAppBar(context,
              title: 'Update Password',
              onPressed: () => Navigator.pop(context)),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: model.resetPasswordFormKey,
              child: ListView(
                children: [
                  verticalSpaceLarge,
                  cwEADetailsTile(context, 'Want to update password ??',
                      subtitle:
                          'Enter your email, phone, or username and we\'ll send you a link to get back into your account.'),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEATextField(context, model.emailTech, 'Email',
                      onChanged: (value) {
                    model.updateEmailEmpty();
                  }, validator: (value) {
                    if (!isEmail(value!)) {
                      return customSnackbars.errorSnackbar(context,
                          title: 'Provide a valid email address');
                    }
                  }),
                  verticalSpaceLarge,
                  cwAuthProceedButton(
                    context,
                    buttonTitle: 'Send Reset Link',
                    isActive: model.emailNotEmpty,
                    isLoading: model.isBusy,
                    onTap: () {
                      if (model.resetPasswordFormKey.currentState!.validate()) {
                        model.resetPassword(
                            context, model.emailTech.text.trim());
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