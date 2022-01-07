import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';
import 'dart:math' as math;

import 'package:spring/spring.dart';

class ThirdView extends StatefulWidget {
  const ThirdView(this.pageController, {Key? key}) : super(key: key);
  final PageController pageController;

  @override
  State<ThirdView> createState() => _ThirdViewState();
}

class _ThirdViewState extends State<ThirdView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 100,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).colorScheme.isDarkTheme
              ? Brightness.dark
              : Brightness.light,
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  navService.materialPageRoute(
                    context,
                    const WelcomeView(),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.mediumBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          horizontalSpaceRegular,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Spring.translate(
              beginOffset: const Offset(100, 100),
              endOffset: const Offset(00, 0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: math.pi / 12,
                  child: Transform.translate(
                    offset: const Offset(120, 50),
                    child: Icon(
                      CupertinoIcons.lock,
                      color: Theme.of(context).colorScheme.mediumBlack,
                      size: 550,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceRegular,
                DefaultTextStyle(
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.black,
                      fontSize: 48,
                      fontWeight: FontWeight.w700),
                  child: AnimatedTextKit(
                    pause: const Duration(milliseconds: 10),
                    totalRepeatCount: 1,
                    onFinished: () {
                        navService.materialPageRoute(
                            context, const WelcomeView());
                    },
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Is it\nSecure???',
                        cursor: '',
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        '** **\n*********',
                        cursor: '',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                ),
                Spring.slide(
                    slideType: SlideType.slide_in_left,
                    child: verticalSpaceLarge),
                Spring.slide(
                  slideType: SlideType.slide_in_left,
                  child: Text(
                    'Secure\nby Design',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Spring.slide(
                    slideType: SlideType.slide_in_left,
                    child: verticalSpaceLarge),
                Spring.slide(
                  slideType: SlideType.slide_in_left,
                  child: Text(
                    'Down to the\nLast Detail',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.mediumBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
