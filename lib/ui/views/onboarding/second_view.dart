// import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/welcome/welcome_view.dart';
import 'package:spring/spring.dart';

class SecondView extends StatefulWidget {
  const SecondView(this.pageController, {Key? key}) : super(key: key);
  final PageController pageController;

  @override
  State<SecondView> createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeightPercentage(context, percentage: 0.6),
                width: screenWidth(context),
              ),
              Spring.translate(
                beginOffset: Offset(
                    -screenWidthPercentage(context, percentage: 0.5),
                    -screenHeightPercentage(context, percentage: 0.3)),
                endOffset: const Offset(-120, -90),
                child: const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/img3.jpg'),
                ),
              ),
              Spring.translate(
                beginOffset: Offset(
                    screenWidthPercentage(context, percentage: 0.5),
                    screenHeightPercentage(context, percentage: 0.3)),
                endOffset: const Offset(150, 175),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/img2.jpg'),
                ),
              ),
              Spring.translate(
                beginOffset: Offset(
                    screenWidthPercentage(context, percentage: 0.5),
                    -screenHeightPercentage(context, percentage: 0.3)),
                endOffset: const Offset(100, -150),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage('assets/img1.jpg'),
                ),
              ),
              Spring.translate(
                beginOffset: Offset(
                    -screenWidthPercentage(context, percentage: 0.5),
                    screenHeightPercentage(context, percentage: 0.3)),
                endOffset: const Offset(-90, 200),
                child: const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/img0.jpg'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.lightGrey, borderRadius: BorderRadius.circular(100)),
                child: Image.asset('assets/appicon_xhdpi_gradient.png'),
              )
            ],
          ),
          Spring.slide(
            slideType: SlideType.slide_in_left,
            animStatus: (animationStatus) {
              if (animationStatus == AnimStatus.completed) {
                Future.delayed(const Duration(seconds: 1), () {
                  widget.pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                });
              }
            },
            delay: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Connecting\nTo those\nwho\nmatters',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.black,
                          fontSize: 48,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomPadding(context),
        ],
      ),
    );
  }
}
