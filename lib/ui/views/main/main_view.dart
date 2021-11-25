import 'package:flutter/material.dart';
import 'package:hint/ui/views/chat_list/chat_list_view.dart';
import 'package:hint/ui/views/letters/letters_view.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

final PageController mainViewPageController = PageController(keepPage: true, initialPage: 0);

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  static const String id = '/MainView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, model, child) => Scaffold(
        body: PageView(
          controller: mainViewPageController,
          children: const [
            ChatListView(),
            LettersView(),
          ],
        ),
      ),
    );
  }
}
