import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/verify_phone/verify_phone.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_viewmodel.dart';

class PhoneAuthView extends StatelessWidget {
  final String email;
  final String password;
  final String username;
  const PhoneAuthView({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('PhoneAuthView');
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      viewModelBuilder: () => PhoneAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: const CupertinoNavigationBar(
          middle: Text('PhoneAuth'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceLarge,
              verticalSpaceLarge,
              verticalSpaceLarge,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'Enter the phone number that you want you want to verify',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: inactiveGray),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 60,
                    color: extraLightBackgroundGray,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          model.pickedCountryCode(context);
                        },
                        child: Text(
                          '+${model.countryCode}',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: screenHeightPercentage(context, percentage: 0.4),
                    child: Form(
                      key: model.formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is mandatory to fill';
                          }
                          if (value.length < 5) {
                            return 'enter a valid phone number';
                          } else {
                            return null;
                          }
                        },
                        cursorColor: Colors.blue,
                        controller: model.phoneTech,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: CupertinoColors.extraLightBackgroundGray,
                          filled: true,
                          isDense: true,
                          hintText: 'enter your phone number',
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
                    ),
                  ),
                ],
              ),
              verticalSpaceLarge,
              CupertinoButton(
                color: model.phoneTech.text.isEmpty
                    ? activeBlue.withOpacity(0.5)
                    : activeBlue,
                onPressed: () async {
                  if (model.formKey.currentState!.validate()) {
                    var phoneNumber =
                        '+${model.countryCode} ${model.phoneTech.text}';
                    log.wtf('phoneNumber:$phoneNumber');
                    model.signUpWithPhone(phoneNumber);
                    Navigator.push(
                      context,
                      cupertinoTransition(
                        enterTo: const VerifyPhoneView(),
                        exitFrom: PhoneAuthView(
                          email: email,
                          password: password,
                          username: username,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Verify phone number',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: systemBackground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
