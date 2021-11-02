import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/verify_phone/verify_phone.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_viewmodel.dart';

class PhoneAuthView extends StatelessWidget {
  final String email;
  final String username;
  final User? createdUser;
  const PhoneAuthView({
    Key? key,
    required this.email,
    required this.username,
    required this.createdUser,
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
                  'provide a valid phone number that you want to register',
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
                          if (value.length < 6) {
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
                  final phoneNumber = model.phoneTech.text;
                  if (await model.isPhoneNumberExists(phoneNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: extraLightBackgroundGray,
                        content: Text(
                          'This phone number is already in use',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    );
                  } else {
                    if (model.formKey.currentState!.validate()) {
                      var phoneNumber =
                          '+${model.countryCode}${model.phoneTech.text}';
                      log.wtf('phoneNumber:$phoneNumber');
                      authService.signUpWithPhone(phoneNumber, context);
                      Navigator.push(
                        context,
                        cupertinoTransition(
                          enterTo: VerifyPhoneView(
                            email: email,
                            username: username,
                            createdUser: createdUser,
                            phoneNumber: model.phoneTech.text,
                            countryPhoneCode: '+${model.countryCode}',
                          ),
                          exitFrom: PhoneAuthView(
                            email: email,
                            username: username,
                            createdUser: createdUser,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'verify phone number',
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
