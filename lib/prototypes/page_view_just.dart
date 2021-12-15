import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class JustAnotherPageView extends StatefulWidget {
  const JustAnotherPageView({Key? key}) : super(key: key);

  @override
  State<JustAnotherPageView> createState() => _JustAnotherPageViewState();
}

class _JustAnotherPageViewState extends State<JustAnotherPageView> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.6);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: cwAuthAppBar(context, title: 'PageView'),
      body: PageView.builder(
        // scrollBehavior: const ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.glow),
        scrollBehavior: const CupertinoScrollBehavior(),
        controller: pageController,
        scrollDirection: Axis.vertical,
        padEnds: false,
        itemCount: 20,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                color: Colors.amberAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
