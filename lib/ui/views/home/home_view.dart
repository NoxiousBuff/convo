import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/pods/page_controller_pod.dart';
import 'package:hint/ui/views/letters/letters_view.dart';
import 'package:hint/ui/views/main/main_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          ref, Widget? child) {
        final pageControllerProvider = ref.watch(pageControllerPod);
        return PageView(
          controller: mainViewPageController,
          scrollBehavior: const MaterialScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          physics: pageControllerProvider.currentIndex != 0 ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
          children: const [
            MainView(),
            LettersView(),
          ],
        );
      },
    );
  }
}
