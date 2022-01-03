import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';

class FirstView extends StatelessWidget {
  const FirstView(this.pageController, {Key? key}) : super(key: key);
  final PageController pageController;

  moveFocusToNextPage() {
    pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 100,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            horizontalSpaceRegular,
            Image.asset('assets/appicon_mdpi_gradient.png')
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: screenHeightPercentage(context, percentage: 0.6),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0.4, 1],
                    colors: [
                      Theme.of(context).colorScheme.lightGrey,
                      Theme.of(context).colorScheme.scaffoldColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32)),
              child: DefaultTextStyle(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.black,
                    fontSize: 48,
                    fontWeight: FontWeight.w700),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 10),
                  totalRepeatCount: 1,
                  onFinished: () => moveFocusToNextPage(),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Send\nMessages\nas you\ntype',
                      cursor: '|',
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Whoosh!!!\nNo\nSend\nButton',
                      cursor: '|',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
            ),
            bottomPadding(context),
          ],
        ),
      ),
    );
  }
}
