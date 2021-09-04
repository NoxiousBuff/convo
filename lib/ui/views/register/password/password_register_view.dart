import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/register/username/username_register_view.dart';
import 'package:stacked/stacked.dart';

import 'password_register_viewmodel.dart';

class PasswordRegisterView extends StatelessWidget {
  final String email;
  const PasswordRegisterView({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordRegisterViewModel>.reactive(
      onModelReady: (model) => model.updateUserEmail(email),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: systemBackground,
          // ignore: todo
          //TODO: Apply for dark theme
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          bottomSheet: Container(
            color: systemBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: Color(0x4D000000),
                  thickness: 1.0,
                  height: 0.0,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        child: Icon(CupertinoIcons.check_mark_circled_solid),
                        width: screenWidthPercentage(context, percentage: 0.1),
                      ),
                      Container(
                          width:
                              screenWidthPercentage(context, percentage: 0.8),
                          child: Text(
                              'By Clicking Create Account to agree to our Privacy Policy and Terms and Conditions.'))
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: systemBackground,
          body: Form(
            key: model.passwordFormKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // verticalSpaceLarge,
                  // verticalSpaceLarge,
                  Icon(
                    CupertinoIcons.padlock,
                    size: 70.0,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.openSans(
                            color: CupertinoColors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Make Sure it\'s strong',
                        style: GoogleFonts.openSans(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    autofocus: true,
                    obscureText: !model.isPasswordShown,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is mandatory to fill';
                      }
                      if (value.length < 8) {
                        return 'must be at least 8 characters';
                      } else {
                        return null;
                      }
                    },
                    controller: model.passwordTech,
                    onChanged: (value) => model.updatePasswordEmpty(),
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(model.isPasswordShown
                            ? CupertinoIcons.lock_open
                            : CupertinoIcons.lock),
                        onPressed: () {
                          model.updatePasswordShown();
                        },
                      ),
                      fillColor: CupertinoColors.extraLightBackgroundGray,
                      filled: true,
                      isDense: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: CupertinoColors.lightBackgroundGray,
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: model.passwordEmpty
                              ? Colors.blue.shade700.withOpacity(0.5)
                              : Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: CupertinoButton(
                          child: model.isBusy
                              ? SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: model.passwordEmpty
                              ? null
                              : () {
                                  if (model.passwordFormKey.currentState!
                                      .validate()) {
                                    model.signUpUser();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UsernameRegisterView()));
                                  }
                                },
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        width:
                            screenWidthPercentage(context, percentage: 0.495),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: CupertinoButton(
                          child: Text(
                            'Change Email',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            print(model.passwordTech.text);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      verticalSpaceLarge,
                      verticalSpaceLarge,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => PasswordRegisterViewModel(),
    );
  }
}