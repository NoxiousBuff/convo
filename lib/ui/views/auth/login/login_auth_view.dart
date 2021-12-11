import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/auth/forgot_password/forgot_password_view.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

import 'login_auth_viewmodel.dart';

class LoginAuthView extends StatelessWidget {
  const LoginAuthView({Key? key}) : super(key: key);

  static const String id = '/LoginAuthView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginAuthViewModel>.reactive(
      viewModelBuilder: () => LoginAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: cwAuthAppBar(context, title: 'Login'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.loginFormKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceRegular,
                    cwAuthHeadingTitle(context, title: 'Enter your \ncredentials'),
                    verticalSpaceRegular,
                    cwAuthDescription(context, title: 'Email Address'),
                    verticalSpaceSmall,
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
                        hintStyle:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, gapPadding: 0.0),
                      ),
                    ),
                    cwAuthDescription(context, title: 'Password'),
                    verticalSpaceSmall,
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return customSnackbars.errorSnackbar(context,
                              title: 'Password can not be empty.');
                        } else {
                          return null;
                        }
                      },
                      obscureText: !model.isPasswordShown,
                      onChanged: (password) {
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
                            color: LightAppColors.secondary,
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
                    verticalSpaceMedium,
                    GestureDetector(
                      onTap: () {
                        navService.cupertinoPageRoute(context, const ForgotPasswordAuthView());
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: LightAppColors.secondary,
                            decoration: TextDecoration.underline),
                      ),
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
                              buttonTitle: 'Login',
                              isLoading: model.isBusy,
                              isActive: model.fieldNotEmpty, onTap: () async {
                            final validate = model.loginFormKey.currentState!.validate();
                            if (validate) {
                              model.login(context, model.emailTech.text, model.passwordTech.text);
                            }
                          }),
                    verticalSpaceLarge,
                    bottomPadding(context)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
