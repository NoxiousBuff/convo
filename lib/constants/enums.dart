/// This file is the collection of all the enums found in the app

enum PhoneVerificationState {
  checkingPhoneNumber,
  checkingOtp,
}

enum ForgotPasswordState {
  writingEmail,
  emailSent,
}

enum UserNameExists {
  yes, no, didNotChecked, checking, tooShort
}

