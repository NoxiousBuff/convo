import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/transition/enter_exit_route.dart';
import 'package:hint/views/register/password_register_view.dart';

class UserNameRegisterView extends StatefulWidget {
  final String? email;
  UserNameRegisterView({this.email});

  @override
  _UserNameRegisterViewState createState() => _UserNameRegisterViewState();
}

class _UserNameRegisterViewState extends State<UserNameRegisterView> {
  final TextEditingController userNameTech = TextEditingController();
  bool userNameEmpty = true;
  final _userNameFormKey = GlobalKey<FormState>();
  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  bool _userExist = false;
  checkUserValue<bool>(String user) async {
    await usernameCheck(user).then((val) {
      if (val) {
        print("UserName is Available.");
        setState(() {
          _userExist = val;
        });
      } else {
        print("UserName Already Exists");
        setState(() {
          _userExist = val;
        });
      }
    });
    return _userExist;
  }

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
        key: _userNameFormKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 50.0),
            Icon(
              CupertinoIcons.at,
              size: 70.0,
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find A UserName',
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
                  'Make it Catchy.',
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
                  userNameEmpty = userNameTech.text.isEmpty;
                });
              },
              validator: (value) {
                if (value!.length < 2 || value.isEmpty) {
                  return "Username is too short.";
                } else if (value.length > 32) {
                  return "Username is too long.";
                  // } else if (false) {
                  //   return "username is already exist";
                } else {
                  return null;
                }
              },
              controller: userNameTech,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                fillColor: CupertinoColors.extraLightBackgroundGray,
                filled: true,
                isDense: true,
                hintText: 'Username',
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
              opacity: userNameEmpty ? 0.5 : 1.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(4.0)),
                child: CupertinoButton(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: userNameEmpty
                      ? null
                      : () {
                          if (_userNameFormKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              EnterExitRoute(
                                exitPage: UserNameRegisterView(),
                                enterPage: PasswordRegisterView(
                                  email: widget.email,
                                  userName: userNameTech.text,
                                ),
                              ),
                            );
                          }
                        },
                ),
              ),
            ),
            CupertinoButton(
              child: Text(
                'Back',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
