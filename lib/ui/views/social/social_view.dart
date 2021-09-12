import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialView extends StatefulWidget {
  const SocialView({Key? key}) : super(key: key);

  @override
  _SocialViewState createState() => _SocialViewState();
}

class _SocialViewState extends State<SocialView> {
  PageController controller = PageController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white, systemNavigationBarColor: Colors.black));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        toolbarHeight: 45.0,
        elevation: 0.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Text(
          'Feed',
          style:
              GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(CupertinoIcons.chat_bubble),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.camera,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        scrollDirection: Axis.vertical,
        itemCount: 11,
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/img$i.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@username$i',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Some Text is written here....',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20.0),
                            ),
                            const Text(
                              'Something here too',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20.0),
                            ),
                            const Text(
                              'Maybe "#" hashtages down here',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20.0),
                            ),
                            const Text(
                              'You can choose whatever goes here',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            trailing: const Text(''),
                            title: const Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Icon(
                                Icons.aspect_ratio_rounded,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaY: 24.0, sigmaX: 24.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          height: 45.0,
                                          width: 45.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'images/img${19 - i}.jpg'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 35.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.mode_comment,
                                          size: 35.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.ios_share,
                                          size: 35.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.bookmark,
                                          size: 35.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
