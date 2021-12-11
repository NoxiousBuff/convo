import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/pods/page_controller_pod.dart';
import 'package:hint/ui/views/letters/letters_view.dart';
import 'package:hint/ui/views/main/main_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final pageControllerProvider = pageControllerPod.;
    return Consumer(
      builder: (BuildContext context,
          ref, Widget? child) {
        final pageControllerProvider = ref.watch(pageControllerPod);
        return Theme(
          data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent)),
          child: PageView(
            controller: mainViewPageController,
            physics: pageControllerProvider.currentIndex != 0 ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
            children: const [
              MainView(),
              LettersView(),
            ],
          ),
        );
      },
    );
  }
}
