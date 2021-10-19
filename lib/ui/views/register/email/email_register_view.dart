import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'email_register_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/views/login/login_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:hint/ui/views/register/username/username_register_view.dart';

class EmailRegisterView extends StatefulWidget {
  const EmailRegisterView({Key? key}) : super(key: key);

  @override
  State<EmailRegisterView> createState() => _EmailRegisterViewState();
}

class _EmailRegisterViewState extends State<EmailRegisterView> {
  Widget emailTextFormField(EmailRegisterViewModel model) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'email address is mandatory to fill';
        } else if (!isEmail(value)) {
          return 'provide a valid email address';
        } else if (value.length < 8) {
          return 'must be at least 8 characters';
        } else {
          return null;
        }
      },
      cursorColor: Colors.blue,
      controller: model.emailTech,
      onChanged: (val) => val.toLowerCase(),
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        fillColor: CupertinoColors.extraLightBackgroundGray,
        filled: true,
        isDense: true,
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: CupertinoColors.lightBackgroundGray,
          ),
        ),
      ),
    );
  }

  Widget passwordTextFormField(EmailRegisterViewModel model) {
    return TextFormField(
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
      controller: model.passwordController,
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
          borderSide: const BorderSide(
            color: CupertinoColors.lightBackgroundGray,
          ),
        ),
      ),
    );
  }

  bool isEmpty(EmailRegisterViewModel model) {
    if (model.emailTech.text.isEmpty) {
      return false;
    } else if (model.passwordController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmailRegisterViewModel>.reactive(
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: systemBackground,
          // ignore: todo
          //TODO: Apply for dark theme
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomSheet: Container(
            color: systemBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: Color(0x4D000000),
                  thickness: 1.0,
                  height: 0.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Have An Account.',
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                        },
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: systemBackground,
          body: Form(
            key: model.emailFormKey,
            child: Center(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Icon(
                    CupertinoIcons.person,
                    size: 70.0,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Make Your Credentials',
                        style: GoogleFonts.openSans(
                            color: CupertinoColors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Text(
                        'You will be ask to verify your email',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  emailTextFormField(model),
                  verticalSpaceRegular,
                  passwordTextFormField(model),
                  verticalSpaceLarge,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: !isEmpty(model)
                          ? Colors.blue.shade700.withOpacity(0.5)
                          : Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CupertinoButton(
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: !isEmpty(model)
                          ? null
                          : () {
                              if (model.emailFormKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UsernameRegisterView(
                                      email: model.emailTech.text,
                                      password: model.passwordController.text,
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => EmailRegisterViewModel(),
    );
  }
}
