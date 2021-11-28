import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:stacked/stacked.dart';

import 'letters_viewmodel.dart';

class LettersView extends StatelessWidget {
  const LettersView({Key? key}) : super(key: key);


  static const String id = '/LettersView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LettersViewModel>.reactive(
      viewModelBuilder: () => LettersViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          mainViewPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
          elevation: 0.0,
          title: const Text(
        'Letters',
        style:  TextStyle(
            fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18),
          ),
          backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.scrolledUnder) ? Colors.grey.shade50 : Colors.white;
              }),
          leadingWidth: 56.0 ,
          leading: IconButton(
        color: Colors.black54,
        icon: const Icon(FeatherIcons.arrowLeft),
        onPressed: () {
          mainViewPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        },
          ) ,
        ),
          body: const Center(
            child: Text('LettersView'),
          ),
        ),
      ),
    );
  }
}