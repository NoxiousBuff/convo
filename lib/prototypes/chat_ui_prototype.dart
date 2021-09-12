import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatUiPrototype extends StatefulWidget {
  const ChatUiPrototype({Key? key}) : super(key: key);

  @override
  _ChatUiPrototypeState createState() => _ChatUiPrototypeState();
}

class _ChatUiPrototypeState extends State<ChatUiPrototype> {
  final Color randomColor = Color.fromARGB(Random().nextInt(256),
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor:
            Color.alphaBlend(randomColor.withAlpha(30), Colors.white),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          elevation: 0.0,
          //I could also use Cupertino Back Button
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('images/img2.jpg'),
              ),
              const SizedBox(height: 5),
              Text(
                'Samantha',
                style: GoogleFonts.openSans(
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          toolbarHeight: 70.0,
          centerTitle: true,
          backgroundColor: randomColor.withAlpha(30),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: randomColor.withAlpha(30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: const Text('Text Message', style: TextStyle(color: Colors.black54),),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: randomColor)),
                    ),
                    const SizedBox(width: 5.0),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.gesture),),
                    const SizedBox(width: 5.0),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.camera_alt_outlined),),
                    const SizedBox(width: 5.0),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.photo_album_outlined),),
                    const SizedBox(width: 5.0),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.attach_file_outlined),),
                    const SizedBox(width: 5.0),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.ac_unit),),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
