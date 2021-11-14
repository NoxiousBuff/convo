import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/enums.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/auth/register/username/username_auth_view.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthViewModel extends BaseViewModel {
  final log = getLogger('PhoneAuth');

  final String phoneChecking = 'phoneChecking';
  final String otpChecking = 'otpChecking';

  final phoneFormKey = GlobalKey<FormState>();
  final otpCodeFormKey = GlobalKey<FormState>();

  String _countryCode = '91';
  String get countryCode => _countryCode;

  String _verificationId = '';
  String get verificationId => _verificationId;

  final TextEditingController phoneTech = TextEditingController();

  final TextEditingController otpCodeTech = TextEditingController();

  PhoneAuthCredential? _phoneAuthCredential;
  PhoneAuthCredential? get phoneAuthCredential => _phoneAuthCredential;

  bool _isPhoneEmpty = true;
  bool get isPhoneEmpty => _isPhoneEmpty;

  String _completePhoneNumber = '';
  String get completePhoneNumber => _completePhoneNumber;

  PhoneVerificationState _phoneVerifcationState =
      PhoneVerificationState.checkingPhoneNumber;
  PhoneVerificationState get phoneVerificationState => _phoneVerifcationState;

  void changePhoneVerificationState(PhoneVerificationState localState) {
    _phoneVerifcationState = localState;
    notifyListeners();
  }

  void phoneEmptyStateChanger() {
    _isPhoneEmpty = phoneTech.text.isEmpty;
    _completePhoneNumber = '+$_countryCode${phoneTech.text}';
    notifyListeners();
  }

  void getCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  Future pickedCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      exclude: <String>['KN', 'MF'],
      showPhoneCode: true,
      onSelect: (Country country) {
        getCode(country.phoneCode);
        log.wtf(country.phoneCode);
      },
      countryListTheme: const CountryListThemeData(
        textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          contentPadding: EdgeInsets.all(0),
          border:
              OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 0.0),
        ),
      ),
    );
  }

  Future<void> linkPhoneToUser(BuildContext context, PhoneAuthCredential credential) async {
    setBusyForObject(otpChecking, true);
    await FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential).then((value){
      navService.materialPageRoute(context, UsernameAuthView(phoneNumber: phoneTech.text, countryCode: '+$countryCode',));
    }).catchError((e) {
      customSnackbars.errorSnackbar(context, title: e);
    });
    setBusyForObject(otpChecking, false);
    log.w('Phone Auth Credential: $phoneAuthCredential');
    customSnackbars.successSnackbar(context,
            title: 'Your phone number has been successfully linked.');
  }

  Future<void> verifyingPhoneNumber(BuildContext context) async {
    setBusyForObject(phoneChecking, true);
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completePhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log.w('Phone Auth Credential: $credential');
        linkPhoneToUser(context, credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log.e(e.message);
          customSnackbars.errorSnackbar(context,
            title: 'Invalid phone number.');
        } else {
          log.e(
              'This was the error in creating phone auth credential : ${e.message}');
        }
        log.e(e.message);
        changePhoneVerificationState(PhoneVerificationState.checkingPhoneNumber);
        customSnackbars.infoSnackbar(context,
            title: 'Type your phone number correctly.');
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        notifyListeners();
        customSnackbars.infoSnackbar(context,
            title: 'Code has been sent successfully.');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    setBusyForObject(phoneChecking, false);
  }

  @override
  void dispose() {
    super.dispose();
    phoneTech.dispose();
    otpCodeTech.dispose();
  }
}
