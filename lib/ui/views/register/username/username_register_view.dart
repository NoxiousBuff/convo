import 'package:hint/app/app_logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/register/phone_auth/phone_auth_view.dart';
import 'package:hint/ui/views/register/username/username_register_viewmodel.dart';

class UsernameRegisterView extends StatefulWidget {
  final String email;
  final User? fireUser;
  final String password;
  const UsernameRegisterView(
      {Key? key,
      required this.email,
      required this.password,
      required this.fireUser})
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

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     final user = widget.fireUser;
  //     if (user != null && user.emailVerified) {
  //       setState(() {
  //         isEmailVerfied = user.emailVerified;
  //       });
  //     }
  //     getLogger('UsernameRegistrationView')
  //         .wtf('isEmailVerfied:$isEmailVerfied');
  //   } else {
  //     getLogger('App is not resumed');
  //   }
  // }

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
                          ? () async {
                              final username = model.usernameTech.text;
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (await model.checkIsUsernameExists(username)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: extraLightBackgroundGray,
                                    content: Text(
                                      'This username is not available',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                );
                              } else {
                                if (model.key.currentState!.validate()) {
                                  final user = widget.fireUser;

                                  if (user != null) {
                                    getLogger('usernameview')
                                        .wtf(user.emailVerified);
                                    model.createAppWriteUser(
                                      context,
                                      username: username,
                                      email: widget.email,
                                      password: widget.password,
                                      fireUser: widget.fireUser,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            extraLightBackgroundGray,
                                        content: Text(
                                          'You didn\'t verify your email',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
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
