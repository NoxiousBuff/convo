import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

import 'forgot_password_viewmodel.dart';

class ForgotPasswordAuthView extends StatelessWidget {
  const ForgotPasswordAuthView({Key? key}) : super(key: key);

  static const String id = '/ForgotPasswordAuthView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordAuthViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: cwAuthAppBar(context, title: 'Forgot Password'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: model.forgotPasswordFormKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceRegular,
                    cwAuthHeadingTitle(context, title: 'Enter your \nemail'),
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
                      onChanged: (val) => model.updateEmailEmpty(),
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
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      cwAuthProceedButton(
                        context,
                        buttonTitle: 'Reset Password',
                        isLoading: model.isBusy,
                        onTap: () async {
                          final validate = model
                              .forgotPasswordFormKey.currentState!
                              .validate();
                          if (validate) {
                            await model.forgotPassword(
                                context, model.emailTech.text);
                          }
                        },
                        isActive: model.emailNotEmpty,
                      ),
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
