import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/forgot_password/forgot_password_view.dart';
import 'package:hint/ui/views/register/email/email_register_view.dart';
import 'package:stacked/stacked.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
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
                      'Don\'t Have An Account.',
                    ),
                    CupertinoButton(
                      onPressed: () => Navigator.push(
                          context,
                          cupertinoTransition(
                            enterTo: const EmailRegisterView(),
                            exitFrom: const LoginView(),
                          )),
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Register',
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
        body: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const Icon(
                CupertinoIcons.hand_thumbsup,
                size: 70.0,
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.openSans(
                        color: CupertinoColors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Good To Have You',
                    style: GoogleFonts.openSans(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              verticalSpaceMedium,
              TextFormField(
                onChanged: (value) {
                  model.updateEmailEmpty();
                },
                controller: model.emailTech,
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
              verticalSpaceTiny,
              TextFormField(
                obscureText: !model.isPasswordShown,
                onChanged: (value) {
                  model.updatePasswordEmpty();
                },
                controller: model.passwordTech,
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
              ),
              verticalSpaceLarge,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: model.emailEmpty || model.passwordEmpty
                      ? Colors.blue.shade700.withOpacity(0.5)
                      : Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CupertinoButton(
                  child: model.isBusy
                      ? const SizedBox(
                          height: 17,
                          width: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'LogIn',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: model.emailEmpty || model.passwordEmpty
                      ? null
                      : () {
                          model.logIn(
                            email: model.emailTech.text,
                            password: model.passwordTech.text,
                            onComplete: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChatListView()));
                            },
                          );
                        },
                ),
              ),
              verticalSpaceSmall,
              Container(
                width: screenWidthPercentage(context, percentage: 0.495),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CupertinoButton(
                  child: const Text(
                    'Forgot Password ?',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    getLogger('Login View').wtf(model.passwordTech.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordView(),
                      ),
                    );
                  },
                ),
              ),
              verticalSpaceLarge,
              verticalSpaceLarge,
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
