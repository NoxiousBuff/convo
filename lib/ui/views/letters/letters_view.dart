import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hint/ui/views/received_letters/received_letters_view.dart';
import 'package:hint/ui/views/send_letters/send_letters_view.dart';
import 'package:stacked/stacked.dart';

import 'letters_viewmodel.dart';

class LettersView extends StatefulWidget {
  const LettersView({Key? key}) : super(key: key);

  static const String id = '/LettersView';

  @override
  State<LettersView> createState() => _LettersViewState();
}

class _LettersViewState extends State<LettersView>
    with SingleTickerProviderStateMixin {
  late TabController lettersTab;

  @override
  void initState() {
    super.initState();
    lettersTab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LettersViewModel>.reactive(
      viewModelBuilder: () => LettersViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          mainViewPageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
          return false;
        },
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text(
                'Letters',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18),
              ),
              backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.scrolledUnder)
                    ? Colors.grey.shade50
                    : Colors.white;
              }),
              leadingWidth: 56.0,
              leading: IconButton(
                color: Colors.black54,
                icon: const Icon(FeatherIcons.arrowLeft),
                onPressed: () {
                  mainViewPageController.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                },
              ),
              bottom: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black45,
                controller: lettersTab,
                labelPadding: const EdgeInsets.symmetric(vertical: 16),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                tabs: const [
                   Text('Received'),
                   Text('Sent'),
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
            body: TabBarView(
              physics:const NeverScrollableScrollPhysics(),
              controller: lettersTab,
              children:const [ReceivedLettersView(), SendLettersView()],
            ),
          ),
        ),
      ),
    );
  }
}
