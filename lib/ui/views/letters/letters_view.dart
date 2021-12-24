import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/letter_info/letter_info_view.dart';
import 'package:hint/ui/views/main/main_view.dart';
import 'package:hint/ui/views/received_letters/received_letters_view.dart';
import 'package:hint/ui/views/search_to_write_letter/search_to_write_letter_view.dart';
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            navService.materialPageRoute(context, const LetterInfoView());
          },
          icon: const Icon(FeatherIcons.info),
          color:Theme.of(context).colorScheme.mediumBlack,
        ),
        horizontalSpaceSmall,
      ],
      elevation: 0.0,
      title:  Text(
        'Letters',
        style: TextStyle(
            fontWeight: FontWeight.w700, color:Theme.of(context).colorScheme.black, fontSize: 18),
      ),
      backgroundColor: Theme.of(context).colorScheme.lightGrey,
      leadingWidth: 56.0,
      leading: IconButton(
        color:Theme.of(context).colorScheme.mediumBlack,
        icon: const Icon(FeatherIcons.arrowLeft),
        onPressed: () {
          mainViewPageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        },
      ),
      bottom: TabBar(
        labelColor:Theme.of(context).colorScheme.black,
        indicatorColor:Theme.of(context).colorScheme.mediumBlack,
        controller: lettersTab,
        labelPadding: const EdgeInsets.symmetric(vertical: 16),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        tabs: const [
          Text('Received'),
          Text('Sent'),
        ],
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  TabBarView _buildTabBarView(BuildContext context) {
    return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: lettersTab,
              children: const [ReceivedLettersView(), SendLettersView()],
            );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return OpenContainer(
              closedElevation: 0,
              openElevation: 0,
              closedColor: Colors.transparent,
              closedBuilder: (context, onPressed) {
                return FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  onPressed: onPressed,
                  backgroundColor: Theme.of(context).colorScheme.blue,
                  child: const Icon(FeatherIcons.edit),
                );
              },
              openBuilder: (context, onPressed) {
                return const SearchToWriteLetterView();
              },
            );
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
            floatingActionButton: _buildAnimatedFAB(context),
            appBar: _buildAppBar(context),
            body: _buildTabBarView(context),
          ),
        ),
      ),
    );
  }
}
