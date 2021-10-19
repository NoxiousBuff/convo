import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:hint/ui/views/register/verify_phone/verifyphone_viewmodel.dart';

class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  late OTPTextEditController controller;

  final scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 5,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{5})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VerifyPhone>.reactive(
      viewModelBuilder: () => VerifyPhone(),
      builder: (context, model, child) => Scaffold(
        appBar: const CupertinoNavigationBar(
          middle: Text('VerifyPhone'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceLarge,
              verticalSpaceLarge,
              verticalSpaceLarge,
              Text(
                'Enter the verification code you received',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: inactiveGray),
              ),
              verticalSpaceMedium,
              Form(
                key: model.formKey,
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  child: PinPut(
                    fieldsCount: 5,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'code length must be 6';
                      }
                    },
                    controller: controller,
                    focusNode: model.pinPutFocusNode,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend Code',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: activeBlue),
                  ),
                ),
              ),
              verticalSpaceLarge,
              CupertinoButton(
                color: activeBlue,
                onPressed: () {
                  if (model.formKey.currentState!.validate()) {}
                },
                child: Text(
                  'Next',
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
