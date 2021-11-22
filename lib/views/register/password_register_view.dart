import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/services/auth_methods.dart';
import 'package:hint/transition/enter_exit_route.dart';
import 'package:hint/views/register/photo_register_view.dart';

class PasswordRegisterView extends StatefulWidget {
  final String? email;
  final String? userName;

  PasswordRegisterView({this.email, this.userName});

  @override
  _PasswordRegisterViewState createState() => _PasswordRegisterViewState();
}

class _PasswordRegisterViewState extends State<PasswordRegisterView> {
  final TextEditingController passwordTech = TextEditingController();
  bool isSignedIn = false;
  final AuthMethods _authMethods = AuthMethods();
  final _passwordFormKey = GlobalKey<FormState>();
  bool passwordEmpty = true;
  bool isNotVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
                    'Already Have An Account.',
                  ),
                  CupertinoButton(
                    onPressed: () {},
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
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
        key: _passwordFormKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 50.0),
            Icon(
              CupertinoIcons.padlock,
              size: 70.0,
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Password',
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
                  'Make Sure it\'s strong',
                  style: GoogleFonts.openSans(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: isNotVisible,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is mandatory to fill';
                }
                if (value.length < 8) {
                  return 'must be at least 8 characters';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  passwordEmpty = passwordTech.text.isEmpty;
                });
              },
              controller: passwordTech,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNotVisible = !isNotVisible;
                      });
                    },
                    child: isNotVisible
                        ? Icon(
                            Icons.visibility_outlined,
                            color: Colors.blue.shade700,
                            size: 24.0,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.blue.shade700,
                            size: 24.0,
                          )),
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
              opacity: passwordEmpty ? 0.5 : 1.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(4.0)),
                child: CupertinoButton(
                  child: isSignedIn
                      ? CircularProgressIndicator.adaptive()
                      : Text(
                          'Complete Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: passwordEmpty
                      ? null
                      : () async {
                          if (_passwordFormKey.currentState!.validate()) {
                            setState(() {
                              isSignedIn = true;
                            });
                            await _authMethods.signUp(
                                userName: widget.userName!,
                                email: widget.email!,
                                password: passwordTech.text,
                                onComplete: () {
                                  Navigator.push(
                                      context,
                                      EnterExitRoute(
                                          exitPage: PasswordRegisterView(),
                                          enterPage: PhotoRegisterView()));
                                },
                                randomError: () {
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
                                          'Something fishy prevent the registration. Please try again later.',
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
                                weakPassword: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0)),
                                        title: Text(
                                          'Sign Up failed!!',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Password is too weak',
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
                                accountExists: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0)),
                                        title: Text(
                                          'Sign Up failed',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Account Already Exists.',
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
