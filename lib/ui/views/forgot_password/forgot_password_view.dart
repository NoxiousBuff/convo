import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'forgot_password_viewmodel.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const Icon(
                CupertinoIcons.envelope,
                size: 70.0,
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Email',
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
                    'You\'ll get a email to change your password.',
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
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    model.forgotPassword(
                      model.emailTech.text,
                      onComplete : () {},
                      onError : () {},
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
      viewModelBuilder: () => ForgotPasswordViewModel(),
    );
  }
}