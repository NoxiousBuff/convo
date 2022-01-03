import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/onboarding/first_view.dart';
import 'package:hint/ui/views/onboarding/second_view.dart';
import 'package:hint/ui/views/onboarding/third_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({Key? key}) : super(key: key);

  final PageController onBoardingPageController =
      PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: Stack(
        children: [
          PageView(
            controller: onBoardingPageController,
            scrollBehavior: const CupertinoScrollBehavior(),
            children: [
              FirstView(onBoardingPageController),
              SecondView(onBoardingPageController),
              ThirdView(onBoardingPageController),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      activeDotColor : Theme.of(context).colorScheme.blue,
                      dotColor: Theme.of(context).colorScheme.lightGrey
                    ),
                    controller: onBoardingPageController,
                    count: 3,
                  ),
                  verticalSpaceLarge,
                  bottomPadding(context),
                ],
              ))
        ],
      ),
    );
  }
}
