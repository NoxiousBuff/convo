import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/auth_methods.dart';
import 'package:hint/transition/enter_exit_route.dart';
import 'package:hint/views/home_view.dart';
import 'package:hint/views/register/email_register_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailTech = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  final TextEditingController passwordTech = TextEditingController();
  bool emailEmpty = true;
  bool passwordEmpty = true;
  bool isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        color: Colors.white,
        child: Column(
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
                    'Don\'t Have An Account.',
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EmailRegisterView()));
                    },
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Register',
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
      ),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          SizedBox(height: 50.0),
          Icon(
            CupertinoIcons.hand_thumbsup,
            size: 70.0,
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
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
                'Good To Have You',
                style: GoogleFonts.openSans(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          TextFormField(
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
          SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              setState(() {
                passwordEmpty = passwordTech.text.isEmpty;
              });
            },
            controller: passwordTech,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              fillColor: CupertinoColors.extraLightBackgroundGray,
              filled: true,
              isDense: true,
              hintText: 'Password',
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
            opacity: emailEmpty || passwordEmpty ? 0.5 : 1.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(4.0)),
              child: CupertinoButton(
                child: isSignedIn
                    ? CircularProgressIndicator.adaptive()
                    : Text(
                        'LogIn',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: emailEmpty || passwordEmpty
                    ? null
                    : () async {
                        setState(() {
                          isSignedIn = true;
                        });
                        await _authMethods.logIn(
                            email: emailTech.text,
                            password: passwordTech.text,
                            onComplete: () {
                              Navigator.push(
                                  context,
                                  EnterExitRoute(
                                      exitPage: LoginView(),
                                      enterPage: HomeView()));
                            },
                            onError: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0)),
                                    title: Text(
                                      'Error',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                      'Something fishy prevent the  process. Make sure you have a decent internet connection. Please try again later.',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      CupertinoButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            noAccountExists: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0)),
                                    title: Text(
                                      'Incorrect Username or password.',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                      'Please make sure you are typing correctly.',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      CupertinoButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            });
                        setState(() {
                          isSignedIn = false;
                        });
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
