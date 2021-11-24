import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

import 'credential_auth_viewmodel.dart';

class CredentialAuthView extends StatelessWidget {
  const CredentialAuthView({Key? key}) : super(key: key);

  static const String id = '/CredentialAuthView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CredentialAuthViewModel>.reactive(
      viewModelBuilder: () => CredentialAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: cwAuthAppBar(context, title: 'SignUp'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.credentialFormKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceRegular,
                    cwAuthHeadingTitle(context,
                        title: 'What\'re your \ncredentials?'),
                    verticalSpaceRegular,
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Email address can not be empty!!');
                        } else if (!isEmail(value)) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Provide a valid email address');
                        } else if (value.length < 8) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Must be at least 8 characters');
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) => model.areFieldNotEmpty(),
                      textCapitalization: TextCapitalization.none,
                      controller: model.emailTech,
                      autofocus: true,
                      autofillHints: const [AutofillHints.email],
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                      showCursor: true,
                      cursorColor: LightAppColors.primary,
                      cursorHeight: 32,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, gapPadding: 0.0),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Password can not be empty.');
                        } else if (!model.isPasswordValid(value)) {
                          return customSnackbars.errorSnackbar(context,
                              title:
                                  'Create a strong password.');
                        } else {
                          return null;
                        }
                      },
                      obscureText: !model.isPasswordShown,
                      onChanged: (password) {
                        model.isPasswordValid(password);
                        model.areFieldNotEmpty();
                      },
                      controller: model.passwordTech,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                      showCursor: true,
                      cursorColor: LightAppColors.primary,
                      cursorHeight: 32,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            color: AppColors.blue,
                            icon: Icon(model.isPasswordShown
                                ? CupertinoIcons.lock_open
                                : CupertinoIcons.lock),
                            onPressed: () {
                              model.updatePasswordShown();
                            },
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                          contentPadding: const EdgeInsets.all(0),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none, gapPadding: 0.0)),
                    ),
                    verticalSpaceRegular,
                    Wrap(
                      spacing: 0.0,
                      children: [
                        cwAuthCheckingTile(
                            title: 'Lower Case', value: model.hasLowercase),
                        cwAuthCheckingTile(
                            title: 'Upper Case', value: model.hasUppercase),
                        cwAuthCheckingTile(
                            title: 'Numbers', value: model.hasDigits),
                        cwAuthCheckingTile(
                            title: 'Special Characters',
                            value: model.hasSpecialCharacters),
                        cwAuthCheckingTile(
                            title: 'Min 8 letters', value: model.hasMinLength),
                      ],
                    ),
                    bottomPadding(context)
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cwAuthProceedButton(context,
                          buttonTitle: 'Next',
                          isLoading: model.isBusy,
                          isActive: model.fieldNotEmpty, onTap: () async {
                        final validate =
                            model.credentialFormKey.currentState!.validate();
                        if (validate) {
                          await model.signUp(
                            context,
                            email: model.emailTech.text,
                            password: model.passwordTech.text,
                          );
                        }
                      }),
                      verticalSpaceLarge,
                      bottomPadding(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}