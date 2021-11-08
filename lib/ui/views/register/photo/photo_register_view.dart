import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class PhotoRegisterView extends StatelessWidget {
  const PhotoRegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          const SizedBox(height: 50.0),
          const Icon(
            CupertinoIcons.camera,
            size: 70.0,
          ),
          const SizedBox(height: 30.0),
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
          const SizedBox(height: 10.0),
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
          const SizedBox(height: 30.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(4.0)),
            child: CupertinoButton(
              child: const Text(
                'Add A Photo',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const PhotoRegisterView()));
              },
            ),
          ),
          CupertinoButton(
            child: const Text(
              'Skip',
            ),
            onPressed: () {},
          ),
            const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
