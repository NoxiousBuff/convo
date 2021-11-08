import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/ui/views/register/username/username_register_viewmodel.dart';

class UsernameRegisterView extends StatefulWidget {
  final String email;
  final String password;
  final User? createdUser;
  const UsernameRegisterView(
      {Key? key,
      required this.email,
      required this.password,
      required this.createdUser})
      : super(key: key);

  @override
  State<UsernameRegisterView> createState() => _UsernameRegisterViewState();
}

class _UsernameRegisterViewState extends State<UsernameRegisterView>
    with WidgetsBindingObserver {
  bool isEmailVerfied = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UsernameRegisterViewModel>.reactive(
      disposeViewModel: true,
      onDispose: (model) {
        model.usernameTech.dispose();
      },
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: systemBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: systemBackground,
          body: Center(
            child: Form(
              key: model.key,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Icon(
                    CupertinoIcons.at,
                    size: 70.0,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'What\'s Your Name',
                        style: GoogleFonts.openSans(
                            color: CupertinoColors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: 0.6),
                        child: Text(
                          'we send a verification link to you provided email, you must verify it',
                          maxLines: 2,
                          style: GoogleFonts.openSans(
                              color: Colors.black54,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is mandatory to fill';
                      }
                      if (value.length < 5) {
                        return 'must be at least 5 characters';
                      } else {
                        return null;
                      }
                    },
                    controller: model.usernameTech,
                    onChanged: (value) {
                      value.toLowerCase();
                      model.updateUsernameEmpty();
                    },
                    inputFormatters: [
                      LowerCaseTextFormatter(),
                    ],
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      fillColor: CupertinoColors.extraLightBackgroundGray,
                      filled: true,
                      isDense: true,
                      hintText: 'username',
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
                      color: model.usernameEmpty
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
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: !model.usernameEmpty
                          ? () {
                              final username = model.usernameTech.text;
                              model.usernameChecker(
                                context,
                                username: username,
                                email: widget.email,
                                password: widget.password,
                                createdUser: widget.createdUser,
                              );
                            }
                          : null,
                    ),
                  ),
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => UsernameRegisterViewModel(),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
