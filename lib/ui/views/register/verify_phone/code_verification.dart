import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/register/verify_phone/code_verification_viewmodel.dart';

class CodeVerificationView extends StatefulWidget {
  final String email;
  final String username;
  final User? createdUser;
  final String phoneNumber;
  final String countryPhoneCode;
  const CodeVerificationView({
    Key? key,
    required this.email,
    required this.username,
    required this.createdUser,
    required this.phoneNumber,
    required this.countryPhoneCode,
  }) : super(key: key);

  @override
  State<CodeVerificationView> createState() => _CodeVerificationViewState();
}

class _CodeVerificationViewState extends State<CodeVerificationView> {
  String? getCode;
  String _phoneVerificationId = '';
  final log = getLogger('CodeVerificationView');
  TextEditingController verificationCodeController = TextEditingController();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    super.initState();
    signUpWithPhone(widget.phoneNumber);
  }

  Future<void> signUpWithPhone(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e('The provided phone number is not valid.');
        } else {
          log.e('This was the error in creating phone auth credential : $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Create a PhoneAuthCredential with the code
        setState(() {
          _phoneVerificationId = verificationId;
        });
        log.wtf('VerificationId:$_phoneVerificationId');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdUser = widget.createdUser;
    return ViewModelBuilder<CodeVerificationViewModel>.reactive(
      viewModelBuilder: () => CodeVerificationViewModel(),
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
                      }
                    },
                    autofocus: true,
                    controller: verificationCodeController,
                    focusNode: model.pinPutFocusNode,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: deepPurpleAccent.withOpacity(.5),
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
                    onPressed: () async {
                      final number =
                          widget.countryPhoneCode + widget.phoneNumber;
                      await model.resend(number, context);
                    },
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
                      await model.verifyCode(
                        context,
                        email: widget.email,
                        createdUser: createdUser,
                        username: widget.username,
                        phoneNumber: widget.phoneNumber,
                        verificationId: _phoneVerificationId,
                        smsCode: verificationCodeController.text,
                        countryPhoneCode: widget.countryPhoneCode,
                      );
                    }
                  }
                },
                child: model.isBusy
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation(systemBackground),
                        ),
                      )
                    : Text(
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
