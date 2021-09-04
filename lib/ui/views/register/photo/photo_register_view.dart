import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/ui/views/home/home_view.dart';

class PhotoRegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          SizedBox(height: 50.0),
          Icon(
            CupertinoIcons.camera,
            size: 70.0,
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Profile Photo',
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
                'Add a photo so your friends know it\'s you.',
                style: GoogleFonts.openSans(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(4.0)),
            child: CupertinoButton(
              child: Text(
                'Add A Photo',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => PhotoRegisterView()));
              },
            ),
          ),
          CupertinoButton(
            child: Text(
              'Skip',
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => HomeView()));
            },
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
