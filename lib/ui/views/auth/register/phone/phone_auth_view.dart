import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/auth/register/phone/phone_auth_viewmodel.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthView extends StatelessWidget {
  const PhoneAuthView({Key? key}) : super(key: key);

  static const String id = '/PhoneAuthView';

  // BoxDecoration get _pinPutDecoration {
  //   return BoxDecoration(
  //     border: Border.all(color: Theme.of(context).colorScheme.blue),
  //     borderRadius: BorderRadius.circular(15.0),
  //   );
  // }

  Widget forPhoneNumber(BuildContext context, PhoneAuthViewModel model) {
    return Form(
      key: model.phoneFormKey,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceRegular,
              cwAuthHeadingTitle(context, title: 'What\'s your \nnumber?'),
              verticalSpaceRegular,
              SizedBox(
                width: screenWidth(context),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: GestureDetector(
                        onTap: () {
                          model.pickedCountryCode(context);
                        },
                        child: Text(
                          '+${model.countryCode}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return customSnackbars.errorSnackbar(context,
                                title: 'Phone number can not be empty.');
                          } else {
                            return null;
                          }
                        },
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (_,
                            {required currentLength,
                            maxLength,
                            required isFocused}) {
                          return const SizedBox.shrink();
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) => model.phoneEmptyStateChanger(),
                        controller: model.phoneTech,
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        autofillHints: const [
                          AutofillHints.telephoneNumberNational
                        ],
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.black),
                        showCursor: true,
                        cursorColor: Theme.of(context).colorScheme.blue,
                        cursorHeight: 32,
                        decoration: const InputDecoration(
                          hintText: 'xxxxx xxxxx',
                          hintStyle: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                          contentPadding: EdgeInsets.all(0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none, gapPadding: 0.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomPadding(context)
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cwAuthProceedButton(
                    context,
                    buttonTitle: 'Send Code',
                    isLoading: model.busy(model.phoneChecking),
                    onTap: () async {
                      getLogger('PhoneAuthView').wtf(model.completePhoneNumber);
                      final validate =
                          model.phoneFormKey.currentState!.validate();
                      if (validate) {
                        model.changePhoneVerificationState(
                            PhoneVerificationState.checkingOtp);
                        customSnackbars.infoSnackbar(context,
                            title: 'Waiting for code to auto verify.....');
                        model.verifyingPhoneNumber(context);
                      }
                    },
                    isActive: !model.isPhoneEmpty,
                  ),
                  verticalSpaceLarge,
                  bottomPadding(context)
                ],
              ))
        ],
      ),
    );
  }

  Widget forOtpCode(BuildContext context, PhoneAuthViewModel model) {
    return Form(
      key: model.otpCodeFormKey,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceRegular,
              cwAuthHeadingTitle(context,
                  title: 'Enter the code \nwe sent you'),
              verticalSpaceRegular,
              PinPut(
                validator: (value) {
                  if (value!.isEmpty) {
                    return customSnackbars.errorSnackbar(context,
                        title: 'Code cannot be empty');
                  } else if (value.length < 6) {
                    return customSnackbars.errorSnackbar(context,
                        title: 'Code is incomplete. Check Again');
                  } else {
                    return null;
                  }
                },
                controller: model.otpCodeTech,
                autofocus: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textStyle:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                fieldsCount: 6,
                submittedFieldDecoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                selectedFieldDecoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.blue),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                followingFieldDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.purple,
                  ),
                ),
              ),
              verticalSpaceMedium,
              GestureDetector(
                onTap: () {
                  model.changePhoneVerificationState(
                      PhoneVerificationState.checkingPhoneNumber);
                  model.setBusyForObject(model.otpChecking, false);
                },
                child: Text(
                  'Change Phone Number',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.mediumBlack,
                      decoration: TextDecoration.underline),
                ),
              ),
              bottomPadding(context)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cwAuthProceedButton(
                  context,
                  buttonTitle: 'Verify Code',
                  isLoading: model.busy(model.otpChecking),
                  onTap: () async {
                    getLogger('PhoneAuthView').wtf(model.completePhoneNumber);
                    final validate =
                        model.otpCodeFormKey.currentState!.validate();
                    if (validate) {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: model.verificationId,
                              smsCode: model.otpCodeTech.text);
                      await model.linkPhoneToUser(context, credential);
                    }
                  },
                  isActive: !model.isPhoneEmpty && model.otpSent,
                ),
                verticalSpaceLarge,
                bottomPadding(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      viewModelBuilder: () => PhoneAuthViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.phoneVerificationState ==
              PhoneVerificationState.checkingOtp) {
            model.changePhoneVerificationState(
                PhoneVerificationState.checkingPhoneNumber);
            model.otpSentChanger(false);
          } else {
            return true;
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context, title: 'Phone Verification'),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: model.phoneVerificationState ==
                      PhoneVerificationState.checkingPhoneNumber
                  ? forPhoneNumber(context, model)
                  : forOtpCode(context, model),
            ),
          ),
        ),
      ),
    );
  }
}
