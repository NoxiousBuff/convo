import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/login/login_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/views/register/password/password_register_view.dart';
import 'package:stacked/stacked.dart';
import 'email_register_viewmodel.dart';

class EmailRegisterView extends StatelessWidget {
  const EmailRegisterView({Key? key}) : super(key: key);

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
                        'Provide An Email',
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
                        'You will be asked to verify.',
                        style: GoogleFonts.openSans(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is mandatory to fill';
                      }
                      if (value.length < 8) {
                        return 'must be at least 8 characters';
                      } else if (!EmailValidator.validate(
                          model.emailTech.text)) {
                        return 'This email is not valid';
                      } else {
                        return null;
                      }
                    },
                    controller: model.emailTech,
                    onChanged: (value) => model.updateEmailEmpty(),
                    cursorColor: Colors.blue,
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
                  ),
                  verticalSpaceLarge,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: model.emailEmpty
                          ? Colors.blue.shade700.withOpacity(0.5)
                          : Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CupertinoButton(
                      child: const Text(
                        'Fill Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: model.emailEmpty
                          ? null
                          : () {
                              if (model.emailFormKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordRegisterView(
                                        email: model.emailTech.text),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
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
