import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/pods/genral_code.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/ui/views/register/user_interests/user_interest.dart';
import 'package:hint/ui/views/register/verify_phone/verifyphone_viewmodel.dart';

class VerifyPhoneView extends StatefulWidget {
  final String email;
  final String username;
  final User? createdUser;
  final String phoneNumber;
  const VerifyPhoneView({
    Key? key,
    required this.email,
    required this.username,
    required this.createdUser,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  final log = getLogger('VerifyCode');
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
      codeLength: 6,
      onCodeReceive: (code) {
        log.wtf('Your Application receive code - $code');
        setState(() {
          controller.text = code;
        });
      },
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createdUser = widget.createdUser;
    final pod = context.read(codeProvider);
    final log = getLogger('VerifyPhoneView');
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
                    fieldsCount: 6,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'code length must be 6';
                      } else if (value != pod.optCode) {
                        return 'code didn\'t matched';
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
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
              ),
              verticalSpaceLarge,
              CupertinoButton(
                color: activeBlue,
                onPressed: () async {
                  if (model.formKey.currentState!.validate()) {
                    log.wtf('code verfied successfully');
                    if (createdUser != null) {
                      final credential = pod.phoneAuthCredential;
                      if (credential != null) {
                        Navigator.push(
                          context,
                          cupertinoTransition(
                            enterTo: InterestsView(
                              email: widget.email,
                              username: widget.username,
                              createdUser: widget.createdUser,
                              phoneNumber: widget.phoneNumber,
                            ),
                            exitFrom: VerifyPhoneView(
                              email: widget.email,
                              username: widget.username,
                              createdUser: widget.createdUser,
                              phoneNumber: widget.phoneNumber,
                            ),
                          ),
                        );
                      }
                    }
                  }
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
