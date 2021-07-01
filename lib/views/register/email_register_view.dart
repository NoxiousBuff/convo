import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/transition/enter_exit_route.dart';
import 'package:hint/views/login/login_view.dart';
import 'package:hint/views/register/username_register_view.dart';

class EmailRegisterView extends StatefulWidget {
  @override
  _EmailRegisterViewState createState() => _EmailRegisterViewState();
}

class _EmailRegisterViewState extends State<EmailRegisterView> {
  final TextEditingController emailTech = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  bool emailEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Color(0x4D000000),
            thickness: 1.0,
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already Have An Account.',
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        EnterExitRoute(
                            enterPage: LoginView(),
                            exitPage: EmailRegisterView()));
                  },
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
        key: _emailFormKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 50.0),
            Icon(
              CupertinoIcons.person,
              size: 70.0,
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Provide An Email',
                  style: GoogleFonts.openSans(
                      color: CupertinoColors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You will be asked to verify.',
                  style: GoogleFonts.openSans(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is mandatory to fill';
                }
                if (value.length < 8) {
                  return 'must be at least 8 characters';
                } else if (!EmailValidator.validate(emailTech.text)) {
                  return 'This email is not valid';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  emailEmpty = emailTech.text.isEmpty;
                });
              },
              controller: emailTech,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                fillColor: CupertinoColors.extraLightBackgroundGray,
                filled: true,
                isDense: true,
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Opacity(
              opacity: emailEmpty ? 0.5 : 1.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: CupertinoButton(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: emailEmpty
                      ? null
                      : () {
                          if (_emailFormKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              EnterExitRoute(
                                exitPage: EmailRegisterView(),
                                enterPage: UserNameRegisterView(
                                  email: emailTech.text,
                                ),
                              ),
                            );
                          }
                        },
                ),
              ),
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
