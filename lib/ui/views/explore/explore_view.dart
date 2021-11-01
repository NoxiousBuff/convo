import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'explore_viewmodel.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      builder: (context, model, child) => const Scaffold(
        body: Center(
          child: Text('Explore'),
        ),
      ),
    );
  }
}
