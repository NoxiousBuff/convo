import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
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
        return OfflineBuilder(
            child: const Text('data'),
            connectivityBuilder: (context, connectivity, child) {
              bool connected = connectivity != ConnectivityResult.none;
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
                      children: [
                        verticalSpaceLarge,
                        cwEADetailsTile(context, 'Want to update password ??',
                            subtitle: 'Enter your password.'),
                        verticalSpaceRegular,
                        const Divider(),
                        verticalSpaceRegular,
                        cwEADescriptionTitle(
                            context, 'Type Your Current Password'),
                        cwEATextField(context, model.passwordTech, 'Password',
                            onChanged: (value) => model.updatePasswordEmpty()),
                        verticalSpaceRegular,
                        cwEADescriptionTitle(context, 'Type Your New Password'),
                        cwEATextField(
                            context, model.newPasswordTech, 'New Password',
                            onChanged: (value) =>
                                model.updateNewPasswordEmpty()),
                        verticalSpaceLarge,
                        CWAuthProceedButton(
                          
                          buttonTitle: 'Update Password',
                          isActive: model.passwordNotEmpty &&
                              model.newPasswordNotEmpty,
                          isLoading: model.isBusy,
                          onTap: () {
                            final key = model.resetPasswordFormKey;
                            final currentState = key.currentState;
                            if (connected) {
                              if (currentState!.validate()) {
                                model
                                    .updateUserPassword(
                                        context, model.newPasswordTech.text)
                                    .whenComplete(() {
                                  model.passwordTech.clear();
                                  model.newPasswordTech.clear();
                                });
                              }
                            } else {
                              customSnackbars.infoSnackbar(context,
                                  title:
                                      'Make sure you have an active internet connection');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}