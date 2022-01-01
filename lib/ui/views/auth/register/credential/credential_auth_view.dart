import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/auth/register/credential/widgets/terms_of_use.dart';
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
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context, title: 'SignUp'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      style:  TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.black),
                      showCursor: true,
                      cursorColor: Theme.of(context).colorScheme.blue,
                      cursorHeight: 32,
                      keyboardType: TextInputType.emailAddress,
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
                      style:  TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.black),
                      showCursor: true,
                      cursorColor: Theme.of(context).colorScheme.blue,
                      cursorHeight: 32,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            color: Theme.of(context).colorScheme.mediumBlack,
                            icon: Icon(model.isPasswordShown
                                ? FeatherIcons.eye
                                : FeatherIcons.eyeOff),
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
                        cwAuthCheckingTile(context, 
                            title: 'Lower Case', value: model.hasLowercase),
                        cwAuthCheckingTile(context, 
                            title: 'Upper Case', value: model.hasUppercase),
                        cwAuthCheckingTile(context, 
                            title: 'Numbers', value: model.hasDigits),
                        cwAuthCheckingTile(context, 
                            title: 'Special Characters',
                            value: model.hasSpecialCharacters),
                        cwAuthCheckingTile(context,
                            title: 'Min 8 letters', value: model.hasMinLength),
                      ],
                    ),
                    verticalSpaceLarge,
                    const TermsOfUse(),
                    bottomPadding(context)
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CWAuthProceedButton(
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
