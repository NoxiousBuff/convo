// import 'package:stacked/stacked.dart';
// import "package:flutter/material.dart";
// import 'package:flutter/cupertino.dart';
// import 'package:hint/app/app_colors.dart';
// import 'package:pinput/pin_put/pin_put.dart';
// import 'package:hint/ui/shared/ui_helpers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hint/ui/views/register/email/email_register_view.dart';
// import 'package:hint/ui/views/register/phone_auth/phone_authentication_viewmodel.dart';

// enum MobileVerificationState {
//   SHOW_MOBILE_FORM_STATE,
//   SHOW_OTP_FORM_STATE,
// }

// class PhoneAuthentication extends StatefulWidget {
//   @override
//   _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
// }

// class _PhoneAuthenticationState extends State<PhoneAuthentication> {
//   MobileVerificationState currentState =
//       MobileVerificationState.SHOW_MOBILE_FORM_STATE;

//   final phoneController = TextEditingController();
//   final otpController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String verificationId = '';

//   bool showLoading = false;

//   BoxDecoration get _pinPutDecoration {
//     return BoxDecoration(
//       border: Border.all(color: Colors.deepPurpleAccent),
//       borderRadius: BorderRadius.circular(15.0),
//     );
//   }

//   void signInWithPhoneAuthCredential(
//       PhoneAuthCredential phoneAuthCredential) async {
//     setState(() {
//       showLoading = true;
//     });

//     try {
//       final authCredential =
//           await _auth.signInWithCredential(phoneAuthCredential);

//       setState(() {
//         showLoading = false;
//       });

//       if (authCredential.user != null) {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const EmailRegisterView()));
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         showLoading = false;
//       });

//      ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: systemRed,
//           content: Text(
//             e.message!,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyText2!
//                 .copyWith(color: systemBackground),
//           ),
//         ),
//       );
//     }
//   }

//   Widget phoneNumberWidget(PhoneAuthenticationViewModel model) {
//     return Column(
//       children: [
//         verticalSpaceLarge,
//         verticalSpaceLarge,
//         verticalSpaceLarge,
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           child: Text(
//             'provide a valid phone number that you want to register',
//             textAlign: TextAlign.center,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(color: inactiveGray),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 50,
//               width: 60,
//               color: extraLightBackgroundGray,
//               child: Center(
//                 child: TextButton(
//                   onPressed: () {
//                     model.pickedCountryCode(context);
//                   },
//                   child: Text(
//                     '+${model.countryCode}',
//                     style: Theme.of(context).textTheme.bodyText2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             SizedBox(
//               width: screenHeightPercentage(context, percentage: 0.4),
//               child: Form(
//                 key: model.phoneNumberFormKey,
//                 child: TextFormField(
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'This field is mandatory to fill';
//                     }
//                     if (value.length < 8) {
//                       return 'enter a valid phone number';
//                     } else {
//                       return null;
//                     }
//                   },
//                   cursorColor: activeBlue,
//                   controller: phoneController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     fillColor: extraLightBackgroundGray,
//                     filled: true,
//                     isDense: true,
//                     hintText: 'enter your phone number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide.none,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: const BorderSide(
//                         color: extraLightBackgroundGray,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         verticalSpaceLarge,
//         CupertinoButton(
//           color: phoneController.text.isEmpty
//               ? activeBlue.withOpacity(0.5)
//               : activeBlue,
//           onPressed: () async {
//             if (model.phoneNumberFormKey.currentState!.validate()) {
//               setState(() {
//                 showLoading = true;
//               });
//               var phoneNumber = '+${model.countryCode}${phoneController.text}';
//               await _auth.verifyPhoneNumber(
//                 phoneNumber: phoneNumber,
//                 verificationCompleted: (phoneAuthCredential) async {
//                   setState(() {
//                     showLoading = false;
//                   });
//                 },
//                 verificationFailed: (verificationFailed) async {
//                   setState(() {
//                     showLoading = false;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: systemRed,
//                       content: Text(
//                         'verification failed',
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                     ),
//                   );
//                 },
//                 codeSent: (verificationId, resendingToken) async {
//                   setState(() {
//                     showLoading = false;
//                     currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
//                     this.verificationId = verificationId;
//                   });
//                 },
//                 codeAutoRetrievalTimeout: (verificationId) async {},
//               );
//             }
//           },
//           child: model.isBusy
//               ? const SizedBox(
//                   height: 15,
//                   width: 15,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 1.5,
//                     valueColor: AlwaysStoppedAnimation(systemBackground),
//                   ),
//                 )
//               : Text(
//                   'Verify',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyText2!
//                       .copyWith(color: systemBackground),
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget smsCodeVerificationWidget(PhoneAuthenticationViewModel model) {
//     return Column(
//       children: [
//         verticalSpaceLarge,
//         verticalSpaceLarge,
//         verticalSpaceLarge,
//         Text(
//           'Enter the verification code you received',
//           style: Theme.of(context)
//               .textTheme
//               .bodyText1!
//               .copyWith(color: inactiveGray),
//         ),
//         verticalSpaceMedium,
//         Form(
//           key: model.smsCodeFormKey,
//           child: Container(
//             color: Colors.white,
//             margin: const EdgeInsets.all(20.0),
//             padding: const EdgeInsets.all(20.0),
//             child: PinPut(
//               fieldsCount: 6,
//               validator: (value) {
//                 if (value!.length < 6) {
//                   return 'code length must be 6';
//                 }
//               },
//               controller: otpController,
//               submittedFieldDecoration: _pinPutDecoration.copyWith(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               selectedFieldDecoration: _pinPutDecoration,
//               followingFieldDecoration: _pinPutDecoration.copyWith(
//                 borderRadius: BorderRadius.circular(5.0),
//                 border: Border.all(
//                   color: deepPurpleAccent.withOpacity(.5),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: TextButton(
//               onPressed: () async {},
//               child: Text(
//                 'Resend Code',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText2!
//                     .copyWith(color: activeBlue),
//               ),
//             ),
//           ),
//         ),
//         verticalSpaceLarge,
//         CupertinoButton(
//           color: activeBlue,
//           onPressed: () {
//             if (model.smsCodeFormKey.currentState!.validate()) {
//               PhoneAuthCredential phoneAuthCredential =
//                   PhoneAuthProvider.credential(
//                       verificationId: verificationId,
//                       smsCode: otpController.text);

//               signInWithPhoneAuthCredential(phoneAuthCredential);
//             }
//           },
//           child: Text(
//             'OTP Button',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyText2!
//                 .copyWith(color: systemBackground),
//           ),
//         ),
//       ],
//     );
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<PhoneAuthenticationViewModel>.reactive(
//       viewModelBuilder: () => PhoneAuthenticationViewModel(),
//       builder: (context, model, child) {
//         return Scaffold(
//           key: _scaffoldKey,
//           body: SingleChildScrollView(
//             child: showLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
//                     ? phoneNumberWidget(model)
//                     : smsCodeVerificationWidget(model),
//             padding: const EdgeInsets.all(16),
//           ),
//         );
//       },
//     );
//   }
// }
